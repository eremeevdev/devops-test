package main

import (
	"database/sql"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

// Response структура для JSON ответа
type Response struct {
	Text string `json:"text"`
}

var db *sql.DB

func main() {
	// Parse database configuration flags
	dbHost := flag.String("db-host", "127.0.0.1", "Database host")
	dbPort := flag.String("db-port", "3306", "Database port")
	dbUser := flag.String("db-user", "appuser", "Database user")
	dbPassword := flag.String("db-password", "secret123", "Database password")
	dbName := flag.String("db-name", "appdb", "Database name")
	flag.Parse()

	// Create database connection string
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", *dbUser, *dbPassword, *dbHost, *dbPort, *dbName)

	// Open database connection
	var err error
	db, err = sql.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	// Test database connection
	if err := db.Ping(); err != nil {
		log.Fatalf("Failed to ping database: %v", err)
	}
	log.Println("Successfully connected to database")

	http.HandleFunc("/api/v1/text", textHandler)

	log.Println("Starting server on :8090")
	if err := http.ListenAndServe(":8090", nil); err != nil {
		log.Fatal(err)
	}
}

func textHandler(w http.ResponseWriter, r *http.Request) {
	var text string

	// Query random text from database
	err := db.QueryRow("SELECT content FROM texts ORDER BY RAND() LIMIT 1").Scan(&text)
	if err != nil {
		log.Printf("Database error: %v", err)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch text"})
		return
	}

	// Формируем ответ
	resp := Response{Text: text}

	// Устанавливаем заголовок и отправляем JSON
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}
