## Servidor ELK

#### Instruções para linux


Para subir os serviços do Elasticsearch e Kibana deve-se executar o docker-compose na raiz deste projeto.
- Comando para construir os containers

`$ docker-compose build`

- Comando para iniciar os containers

`$ nohup docker-compose up &`
      
 Necessário instalar docker, docker-compose e nohup
 
[Tutorial docker](https://www.digitalocean.com/community/tutorials/como-instalar-e-usar-o-docker-no-ubuntu-18-04-pt) (seguir até o passo 2)

[Tutorial docker-compose](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04)

[Nohup](https://www.maketecheasier.com/nohup-and-uses/)

Para utilizar visualização do tipo Region Map no Kibana, deve-se instalar a extensão **Allow CORS: Access-Control-Allow-Origin** para o [Chrome](https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf)  ou no [Firefox](https://addons.mozilla.org/pt-BR/firefox/addon/access-control-allow-origin/)

Após instalar a extensão Allow CORS, limpar o cache do navegador e recarregar a página.
