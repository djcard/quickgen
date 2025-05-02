# Quick Gen

## Background

Quick Gen is a CommandBox module which creates entities designed to be used with Quick. 

## Installation

Install from CommandBox by typing `commandbox-quickgen`.

## Commands and Usage

 Configure - walks the user through creating a datasource

 Generate - accepts a datasource, database name, table name and creates a quick entity from the fields found in that table. Tabbing for the required parameter 'datasource' will search for datasources in CommandBox, .cfconfig.json files in the current folder (if any) and .cfmigrations.json files / managers in the current folder (if any). If the chosen datasource is not in CommandBox for use, it will be added.

## Changelog

0.0.5 - Adding datasources from .cfconfig.json and .cfmigrations.json files automatically.
