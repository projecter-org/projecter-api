# projecter-api
Api of projecter

## Routes
#### GET projects
```
GET /api/v1/projects HTTP/1.1
Host: api.projecter.org:3000
Content-Type: application/json
Cache-Control: no-cach
```

#### POST new project
```
POST /api/v1/projects HTTP/1.1
Host: api.projecter.org:3000
Content-Type: application/json
Cache-Control: no-cache
{
	"lastname": "McGregor",
	"firstname": "Allan",
	"email": "allan.mcgregor@gmail.com" 
}
```

## Models
* Users
  * id
  * firstname
  * lastname
  * type
  * created_at
  * updated_at
  * emails[]
    * id
    * type
    * email
    * extra
  * phones[]
    * id
    * type
    * number
    * ext
    * extra
  * adresses[]
    * id
    * adress
    * street_number
    * postal_code
    * city
    * region [or state]
    * country

* Client
  * id
  * firstname
  * lastname
  * created_at
  * updated_at
  * emails[]
    * id
    * type
    * email
    * extra
  * phones[]
    * id
    * type
    * number
    * ext
    * extra
  * adresses[]
    * id
    * adress
    * street_number
    * postal_code
    * city
    * region [or state]
    * country
  * projects[]
    * id
    * description
    * due_date
    * created_at
    * updated_at
    * representatives[users_id]
    * shared[]
      * id
      * is_shared
      * with[users_id]
    * items[]
      * id
      * price
      * quantity
      * due_date
      * created_at
      * updated_at
    * invoices[]
      * id
      * adjustements[]
        * id
        * amount
        * extra
        * created_at
        * updated_at
      * items[items_id]
      * created_at
      * updated_at
