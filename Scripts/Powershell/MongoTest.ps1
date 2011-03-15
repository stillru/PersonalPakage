# We assume that the Driver is installed via the MSI.
#[string] $mongoDriverPath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\.NETFramework\AssemblyFolders\MongoDB CSharpDriver 0.11").'(default)';
#Add-Type -Path "$($mongoDriverPath)\MongoDB.Bson.dll";
add-type -Path .\MongoDB.dll

$mongo=new-object MongoDB.Driver.Mongo
$mongo.connect()
$db=$mongo.GetDataBase("movieReviews")
$movies=$db.GetCollection('Movies')

$movie=new-object MongoDB.Driver.document
$movie['title']='Star Wars'
$movie['releaseDate']=Get-Date
$movies.Insert($movie)

$spec=new-object MongoDB.Driver.document
$spec['title']='Star Wars'
$movies.FindOne($spec)
