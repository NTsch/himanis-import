xquery version "3.1";
declare default element namespace "https://heuristnetwork.org";

let $db := doc('export_stutzmann_himanis_20260701124444.xml')/hml/records

(:let $charters := $db/record[type="Act"]
let $results := distinct-values($charters/detail/@conceptID/data())
for $result in $results
order by $result
return <result>{$result}</result>:)

let $fontenay-persons := $db/record[detail[@conceptID="1624-1337"] and type[text() = "Person"]]
let $person-ids := $fontenay-persons/id/text()
let $relations := $db/record[type[text() = "Record relationship"]]
return distinct-values($relations[detail = $person-ids]/detail[@conceptID="2-6"])
