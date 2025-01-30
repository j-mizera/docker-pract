package main

import (
	"github.com/go-chi/chi/v5"
	"io"
	"net/http"
)

func main() {
	router := chi.NewRouter()
	router.Get("/", func(w http.ResponseWriter, request *http.Request) {
		print("req!\n")
		print("reqs!\n")
		io.WriteString(w, "Hi!")
	})
	http.ListenAndServe(":8080", router)
}
