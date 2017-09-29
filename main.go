package main

import (
	"flag"
	"fmt"
	"net/http"
)

// build flags
var (
	Version    string
	Buildstamp string
	Githash    string
)

var (
	version = false
	addr    = ":8080"
	dir     = "./"
)

func init() {
	flag.BoolVar(&version, "v", version, "show version")
	flag.StringVar(&addr, "addr", addr, "address to listen on")
	flag.StringVar(&dir, "dir", dir, "directory to serve files from")
	flag.Parse()
}

func main() {
	if version {
		fmt.Printf("Version data of servdir:")
		fmt.Printf("\n  version=%s\n  buildstamp=%s\n  githash=%s\n\n", Version, Buildstamp, Githash)
		return
	}
	fmt.Printf("listen on addr %s and serve files from directory %s\n", addr, dir)
	panic(http.ListenAndServe(addr, log(http.FileServer(http.Dir(dir)))))
}

func log(h http.Handler) http.Handler {
	hh := func(w http.ResponseWriter, req *http.Request) {
		rec := &recorder{ResponseWriter: w, code: 200}

		h.ServeHTTP(rec, req)

		const format = "%s %s\n      <- %d %s\n\n"
		fmt.Printf(format, req.Method, req.RequestURI, rec.code, http.StatusText(rec.code))
	}
	return http.HandlerFunc(hh)
}

type recorder struct {
	code int
	http.ResponseWriter
}

func (l *recorder) WriteHeader(code int) {
	l.code = code
	l.ResponseWriter.WriteHeader(code)
}
