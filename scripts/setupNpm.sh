#!/bin/bash

npm config set @sixriver:registry https://sixriver.jfrog.io/sixriver/api/npm/npm-local/
npm config set //sixriver.jfrog.io/sixriver/api/npm/npm-local/:_password $NPM_PASSWORD
npm config set //sixriver.jfrog.io/sixriver/api/npm/npm-local/:username kolach
npm config set //sixriver.jfrog.io/sixriver/api/npm/npm-local/:email chikoald@6river.com
npm config set //sixriver.jfrog.io/sixriver/api/npm/npm-local/:always-auth true
