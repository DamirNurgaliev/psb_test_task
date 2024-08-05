# README

## Тестовое задание для ПСБ

Компетенции - базовая составляющая приложения. По моей логике их может создать, например, админ заранее. В требованиях не указана точная логика приложения, но я сделал так, что при
создании/обновлении курса - можно было передать ids компетенций для этого курса. В реальности это логично - мы бы на странице создания курса заранее загрузили все компетенции(через index competencies), чтобы позволить выбрать нужные из них для этого курса.

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