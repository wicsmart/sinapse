# Executar Monstache no Docker junto ao Docker-Compose
 
 
 1. Construir a imagem com nome de monstache-img

    `docker build -t monstache-img .`


2. Executar o a imagem com nome monstache na rede "*docker-compose_my-mongo-cluster*"

    `docker run -d --name monstache --network docker-compose_my-mongo-cluster monstache-img`

3. Entrar no terminal da imagem
    
    `docker run -it monstache bash`
    
4. Executar o arquivo de configuração do monstach

    `nohup monstache -f build/config.toml &`



# Executar Monstache no host

Monstache é um daemon de sincronização escrito em Go que indexa continuamente suas coleções do MongoDB no Elasticsearch. E aqui está como implementar o Monstache em poucas etapas:

Nota: Esta etapa é para servidores baseados no Ubuntu, as mesmas etapas podem ser seguidas para qualquer outro servidor.

1. Instalar "go" no host

    `sudo apt-get install golang-go`
    
2. Baixe o último lançamento da Monstache: https://github.com/rwynn/monstache/releases. Descompacte a pasta. Dentro da pasta você encontrará uma pasta para cada tipo de máquina, no nosso caso o linux-amd64 é o do Ubuntu. Lembre-se do caminho para essa pasta.

3. Exportar o path do Monstache

    `sudo vi ~/.bashrc`
    
4. Adicionar a seguinte linha como path da pasta referente ao SO do host, no caso "*linux-amd64", no arquivo ~/.bashrc 

    `export PATH=“/home/ubuntu/build/linux-amd64:$PATH”`

5. Executar o seguinte comando para habilitar o path para o Monstache

    `source ~/.baschrc`
    
6. Teste se está instalado corretamente verificando a versão 
 
    `monstache -v`
    
7. Iniciar a sincronização com o arquivo de configuração "*config.toml"

    `nohup monstache -f /path/to/config.toml &`

Nota: Monstache usa o oplog MongoDB como uma fonte de eventos. Você precisará certificar-se de que o MongoDB está configurado para produzir um oplog. O oplog pode ser ativado usando uma das seguintes opções:

+ Configurando Conjuntos de Réplicas
+ Passando - master para o processo mongod
    `mongod --master`
+ Configurando o seguinte em /etc/mongod.conf
    `master = true`
    

### Arquivo de configuração config.toml


```
# connection settings

# connect to MongoDB using the following URL
mongo-url = "mongodb://mongo:27017"

# connect to the Elasticsearch REST API at the following node URLs
elasticsearch-urls = ["http://elasticsearch:9200"]

# frequently required settings

# if you don't want to listen for changes to all collections in MongoDB but only a few
# e.g. only listen for inserts, updates, deletes, and drops from mydb.mycollection
# this setting does not initiate a copy, it is a filter on the oplog change listener only

namespace-regex = '^mydb\.mycollection$'

# additionally, if you need to seed an index from a collection and not just listen for changes from the oplog
# you can copy entire collections or views from MongoDB to Elasticsearch

direct-read-namespaces = ["mydb.mycollection", "db.collection", "test.test"]

# if you want to use MongoDB change streams instead of legacy oplog tailing add the following
# in this case you don't need regexes to filter collections.
# change streams require MongoDB version 3.6+
# change streams cannot be combined yet with resume, replay, or cluster options.
# change streams start listening for new changes since the monstache process is started

change-stream-namespaces = ["mydb.mycollection", "db.collection", "test.test"]

#Index Mapping

#With the configuration below documents in the test.test namespace in MongoDB are indexed into the index1 index in #Elasticsearch with the type1 type.

[[mapping]]
namespace = "test.test"
index = "index1"
type = "type1"

[[mapping]]
namespace = "test.test2"
index = "index2"
type = "type2"

# additional settings

# disable PEM validation
mongo-validate-pem-file = false

# use the following user name for Elasticsearch basic auth
#elasticsearch-user = "someuser"

# use the following password for Elasticsearch basic auth
#elasticsearch-password = "somepassword"

# use 4 go routines concurrently pushing documents to Elasticsearch
elasticsearch-max-conns = 4 

# propogate dropped collections in MongoDB as index deletes in Elasticsearch
dropped-collections = false

# propogate dropped databases in MongoDB as index deletes in Elasticsearch
dropped-databases = false

# do not start processing at the beginning of the MongoDB oplog
# if you set the replay to true you may see version conflict messages
# in the log if you had synced previously. This just means that you are replaying old docs which are already
# in Elasticsearch with a newer version. Elasticsearch is preventing the old docs from overwriting new ones.
replay = false

# resume processing from a timestamp saved in a previous run
resume = false

# do not validate that progress timestamps have been saved
resume-write-unsafe = false

# override the name under which resume state is saved
#resume-name = "default"
# exclude documents whose namespace matches the following pattern
namespace-exclude-regex = '^mydb\.ignorecollection$'

# turn on indexing of GridFS file content
index-files = false

# print detailed information including request traces
verbose = true

# do not exit after full-sync, rather continue tailing the oplog
exit-after-direct-reads = false

```

### Importante:
   Para index com campos do tipo float o Monstache indexa como do tipo long, isso pode afetar futuras análises. Portanto, neste caso é necessário criar o index mapeando esses campos do tipo float antes de iniciar a sincronização.

Segue um exemplo de mapping fields para o elasticsearch. Esta request pode ser executada no Kibana.

```
PUT utilizacao_hora
{
  "mappings": {
    "_doc": {
      "properties": {
        "bateria": {
          "type": "float"
        },
        "custo_km": {
          "type": "float"
        },
        "horimetro": {
          "type": "float"
        },
        "odometro": {
          "type": "float"
        },
        "tempo_desligado": {
          "type": "float"
        },
        "tempo_disponivel": {
          "type": "float"
        },
        "tempo_ligado": {
          "type": "float"
        }
      }
    }
  }
}
```
A request acima cria o index `utilizacao_hora` com tipo `_doc` e define os campos explícitos como float.


Referência: https://rwynn.github.io/monstache-site/config/

    
