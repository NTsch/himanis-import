xquery version "3.1";
declare default element namespace "https://heuristnetwork.org";

let $db := doc('Export_stutzmann_himanis_20260701124444.xml')/hml/records

(:let $charters := $db/record[type="Act"]
let $results := distinct-values($charters/detail/@conceptID/data())
for $result in $results
order by $result
return <result>{$result}</result>:)

(:let $fontenay-persons := $db/record[detail[@conceptID="1624-1337"] and type[text() = "Person"]]
let $person-ids := $fontenay-persons/id/text()
let $relations := $db/record[type[text() = "Record relationship"]]
return distinct-values($relations[detail = $person-ids]/detail[@conceptID="2-6"]):)

(:let $fontenay-persons := $db/record[detail[@conceptID="1624-1337"] and type[text() = "Person"]]
return distinct-values($fontenay-persons/detail/@conceptID/data()):)

(:let $fontenay-persons := $db/record[type[text() = "Person"]]
return $fontenay-persons/detail[@conceptID="2-3"]:)

let $charters := $db/record[type="Act"]
return $charters//temporal