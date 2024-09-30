# AstraApp

[![Maintainability](https://api.codeclimate.com/v1/badges/24eb9986d0a40b0bdd68/maintainability)](https://codeclimate.com/repos/66d7811021f4ae08d9f516f0/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/24eb9986d0a40b0bdd68/test_coverage)](https://codeclimate.com/repos/66d7811021f4ae08d9f516f0/test_coverage)

### Performance
[![View performance data on Skylight](https://badges.skylight.io/problem/72WYVhQRGRCi.svg?token=WyNqxdbP3ACgjMVS-oG9dTdSTXexy2TaKYiySANtm6k)](https://www.skylight.io/app/applications/72WYVhQRGRCi)
[![View performance data on Skylight](https://badges.skylight.io/typical/72WYVhQRGRCi.svg?token=WyNqxdbP3ACgjMVS-oG9dTdSTXexy2TaKYiySANtm6k)](https://www.skylight.io/app/applications/72WYVhQRGRCi)
[![View performance data on Skylight](https://badges.skylight.io/rpm/72WYVhQRGRCi.svg?token=WyNqxdbP3ACgjMVS-oG9dTdSTXexy2TaKYiySANtm6k)](https://www.skylight.io/app/applications/72WYVhQRGRCi)
[![View performance data on Skylight](https://badges.skylight.io/status/72WYVhQRGRCi.svg?token=WyNqxdbP3ACgjMVS-oG9dTdSTXexy2TaKYiySANtm6k)](https://www.skylight.io/app/applications/72WYVhQRGRCi)

## Introduction
This is the main application for AstraGoal. This is the application with which end users will interact. The databases for this application is the "source of truth."

## Staging Environment
https://astraapp-f3a1438f8ff1.herokuapp.com

## Tech Stack
* Ruby on Rails v. 7.2.x and Ruby 3.3.x
* PostgreSQL
* [Good Job](https://github.com/bensheldon/good_job) (instead of Sidekiq)
* See the [Gemfile](https://github.com/AstraGoal/AstraApp/blob/main/Gemfile) for more details on what this application uses.

## Basic Architectural Concepts
* **AstraApp** is the "main" app. This is full-stack Rails.
* **AstraStream** is the "customer-facing API." This is an API-only application that customers will use to send data to us. This application then communicates directly with AstraApp. This application is essentially a data-ingest service. AstraStream communicates with AstraGoal via dedicated API endpoints within AstraGoal and authentication is handled via Basic Auth.
* more details coming soon

## Heroku
This application is deployed to Heroku
We use YJIT on Heroku, it should already be enabled, but if we're spinning up a new application instance for some reason, be sure to use ```heroku config:set RUBYOPT="--enable-yjit"``` to enable YJIT. Read more about Heroku YJIT [here.](https://devcenter.heroku.com/articles/ruby-support#yjit) If you want to learn more about the benefits of YJIT, here is a [great article from the Shopify team.](https://shopify.engineering/ruby-yjit-is-production-ready)

### Environment Variables
* ```ENV["RAILS_MASTER_KEY"]```
