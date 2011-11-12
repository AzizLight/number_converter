Number Converter
================

Number Converter is, as its name very explicitly describes it, a number converter. It can convert binary, decimal or hexadecimal numbers to binary, decimal and hexadecimal.

The base of the original number is detected automatically but can be set manually; This is relevent for numbers like 10 that are treated as binary by default.

API
---
The API accepts four types of GET requests.

### GET /:number(.format)

- **HTTP method**: GET
- **Resource URL**: http://numberconverter.heroku.com/:number(.format)
- **Response format**: plain text, HTML, JSON, YAML or CSV

#### :number
This is the number to convert. This can be binary, decimal or hexadecimal. The base of the number will be detected automatically.

####.format
Optional. This is the response format. If you don't submit a format you are going to get the whole webpage back. For this reason, **it is highly recomended to submit a format**. This can be one of the following:

- .txt
- .html
- .json
- .yml
- .csv

#### Examples

GET http://numberconverter.heroku.com/101010.json  
GET http://numberconverter.heroku.com/42.csv

### GET /:base/:number(.format)

- **HTTP method**: GET
- **Resource URL**: http://numberconverter.heroku.com/:base/:number(.format)
- **Response format**: plain text, HTML, JSON, YAML or CSV

#### :base
This is the base of the submitted number (:number). It is in integer form. So for example if you want the submitted number to be binary, the base would be 2; 10 for decimal, 16 for hexadecimal. **The only supported bases for now are binary, decimal and hexadecimal.**

#### :number
This is the number to convert. This can be binary, decimal or hexadecimal. The base of the number will be detected automatically.

####.format
Optional. This is the response format. If you don't submit a format you are going to get the whole webpage back. For this reason, **it is highly recomended to submit a format**. This can be one of the following:

- .txt
- .html
- .json
- .yml
- .csv

#### Examples

GET  http://numberconverter.heroku.com/10/101010.txt  
GET  http://numberconverter.heroku.com/16/2A.html

### GET /:number.format/:base

- **HTTP method**: GET
- **Resource URL**: http://numberconverter.heroku.com/:number(.format)/:base
- **Response format**: plain text, HTML, JSON, YAML or CSV

#### :number
This is the number to convert. This can be binary, decimal or hexadecimal. The base of the number will be detected automatically.

####.format
**Mandatory**. This is the response format. This can be one of the following:

- .txt
- .html
- .json
- .yml
- .csv

#### :base
This is the base of the output number. This means that the response will only contain one number, converted to the submitted base (:base). It is in integer form. So for example if you want the submitted number to be binary, the base would be 2; 10 for decimal, 16 for hexadecimal. **The only supported bases for now are binary, decimal and hexadecimal.**

#### Examples

GET  http://numberconverter.heroku.com/42.txt/2  
GET  http://numberconverter.heroku.com/101010.html/16

### GET /:ibase/:number.format/:obase

- **HTTP method**: GET
- **Resource URL**: http://numberconverter.heroku.com/:ibase/:number(.format)/:obase
- **Response format**: plain text, HTML, JSON, YAML or CSV

#### :ibase
This is the base of the submitted number (:number). It is in integer form. So for example if you want the submitted number to be binary, the base would be 2; 10 for decimal, 16 for hexadecimal. **The only supported bases for now are binary, decimal and hexadecimal.**

#### :number
This is the number to convert. This can be binary, decimal or hexadecimal. The base of the number will be detected automatically.

####.format
**Mandatory**. This is the response format. This can be one of the following:

- .txt
- .html
- .json
- .yml
- .csv

#### :obase
This is the base of the output number. This means that the response will only contain one number, converted to the submitted base (:obase). It is in integer form. So for example if you want the submitted number to be binary, the base would be 2; 10 for decimal, 16 for hexadecimal. **The only supported bases for now are binary, decimal and hexadecimal.**

#### Examples

GET  http://numberconverter.heroku.com/10/101010.csv/2  
GET  http://numberconverter.heroku.com/16/73.json/10
