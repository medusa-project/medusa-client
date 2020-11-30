#!/bin/sh

export MEDUSA_BASE_URL=http://localhost:4567
export MEDUSA_USER=medusa
export MEDUSA_SECRET=secret

bundle exec rake test
