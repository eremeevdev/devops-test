package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"time"
)

// Response структура для JSON ответа
type Response struct {
	Text string `json:"text"`
}

func main() {
	// Инициализация генератора случайных чисел
	rand.Seed(time.Now().UnixNano())

	http.HandleFunc("/api/v1/text", textHandler)

	log.Println("Starting server on :8090")
	if err := http.ListenAndServe(":8090", nil); err != nil {
		log.Fatal(err)
	}
}

func textHandler(w http.ResponseWriter, r *http.Request) {
	texts := []string{
		"Hello from the Go backend!",
		"This is a random text for the DevOps interview.",
		"Good luck with the deployment!",
		"Nginx is waiting for you.",
	}

	// Выбираем случайный текст
	randomText := texts[rand.Intn(len(texts))]

	// Формируем ответ
	resp := Response{Text: randomText}

	// Устанавливаем заголовок и отправляем JSON
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}
