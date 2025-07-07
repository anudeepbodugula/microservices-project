package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

type Publication struct {
	Title  string `json:"title"`
	Author string `json:"author"`
}

func loadEnvAndDSN() (string, error) {
	// Optional for local dev; ignored in Docker
	_ = godotenv.Load()

	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASS")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPass, dbHost, dbPort, dbName)
	return dsn, nil
}

func createPublicationHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	var pub Publication
	if err := json.NewDecoder(r.Body).Decode(&pub); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	dsn, err := loadEnvAndDSN()
	if err != nil {
		http.Error(w, "Error loading environment variables", 500)
		return
	}

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		http.Error(w, "Database connection failed", 500)
		return
	}
	defer db.Close()

	_, err = db.Exec("INSERT INTO publications(title, author) VALUES(?, ?)", pub.Title, pub.Author)
	if err != nil {
		http.Error(w, "Insert failed: "+err.Error(), 500)
		return
	}

	w.WriteHeader(http.StatusCreated)
	fmt.Fprintln(w, "Publication created")
}

func listPublicationsHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	dsn, err := loadEnvAndDSN()
	if err != nil {
		http.Error(w, "Failed to load environment variables", 500)
		return
	}

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		http.Error(w, "Database connection failed", 500)
		return
	}
	defer db.Close()

	rows, err := db.Query("SELECT title, author FROM publications")
	if err != nil {
		http.Error(w, "Query failed", 500)
		return
	}
	defer rows.Close()

	var publications []Publication
	for rows.Next() {
		var pub Publication
		if err := rows.Scan(&pub.Title, &pub.Author); err != nil {
			http.Error(w, "Failed to parse row", 500)
			return
		}
		publications = append(publications, pub)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(publications)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "Service is up")
}

func dbHealthHandler(w http.ResponseWriter, r *http.Request) {
	dsn, err := loadEnvAndDSN()
	if err != nil {
		http.Error(w, "Failed to load environment variables", 500)
		return
	}

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		http.Error(w, "Database connection failed: "+err.Error(), 500)
		return
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		http.Error(w, "Database unreachable: "+err.Error(), 500)
		return
	}

	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "Database connection is OK")
}

func main() {
	http.HandleFunc("/publication", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			createPublicationHandler(w, r)
		} else if r.Method == http.MethodGet {
			listPublicationsHandler(w, r)
		} else {
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		}
	})

	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/db-health", dbHealthHandler)

	log.Println("Listening on :5002...")
	log.Fatal(http.ListenAndServe(":5002", nil))
}
