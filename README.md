## Installation
clone the repo
bundle install
rails server

## Route notes
/ => /tour/new
POST /tour?email=xx   => confirmation email, redirect GET /thanks    #state1
GET /tour/edit?id=xx   => form for info based on tour state
PUT /tour?id,first,last,phone   => redirect GET /tour/edit?id     #state2
PUT /tour?id,date,string,amenities   => success email, redirect GET /success      #state3
PUT /tour?id,rating    => GET /thanks_again    #state4

## Tour states
Requested, basic info, extra info, rating
