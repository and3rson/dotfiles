package main

import "context"

type Widget interface {
    Run(ctx context.Context, updates chan<- Widget)
    Content() string
}
