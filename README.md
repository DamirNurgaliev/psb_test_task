# README

## Тестовое задание для ПСБ

## How to verify

1) Clone this repo
2) Install ruby 3.0.2 (if not installed)
3) Run ```bundle```
4) Run ```bin/rake db:create``` 
5) Run ```bin/rake db:migrate``` 
6) Run ```bin/rake db:seed``` 
7) Start local server with ```bin/rails s``` 
8) Observe API-docs at http://localhost:3000/api-docs/index.html
9) Verify all tests in spec folder (controllers/interactor) with ```bin/rspec spec``` 