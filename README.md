# Progetto Web Library
Applicazione web per un catalogo online di una libreria

## Struttura Progetto
La struttura del progetto consta di 
- web-library : progetto padre
- web-library-fe: progetto angularjs frontend
- web-library-be: modulo war

# Contenitore web-library
Progetto pom padre.
Se si usa Eclipse come ide è sufficiente eseguire l'import come progetto Maven (importare anche i moduli figli) : File->Import->Import as Maven Project

# Modulo web-library-fe
E' un progetto angular con pagina di login e pagina catalogo.
La pagina di login non richiede reali operazioni di autenticazione.
La pagina di catalogo mostra la lista degli autori.

## Installazione ambiente di sviluppo
Per impostare l'ambiente di sviluppo per il progetto angular occorre come prerequisito l'installazione di [Node](https://nodejs.org/)

Quindi eseguire i seguenti comandi
- installazione [bower](http://bower.io/) - <code>npm install -g bower</code>
- installazione pacchetti per la compilazione - <code>npm i & bower i</code>
- installazione [gulp](http://gulpjs.com/) - <code>npm install -g gulp</code>

## Esecuzione della build del frontend
Eseguire il seguente comando - <code>gulp</code>
L'applicazione verrà compilata nella cartella dist.
Verrà anche lanciato un server locale sulla porta 8010 in livereload per caricare l'applicazione.
Lo script si terrà poi in watch sul contenuto della cartella *app* ed effettuerà nuovamente la build appena verrà apportata una modifica al contenuto della cartella.

##Funzionalità implementate
Pagina di login, solo frontend, nessuna validazione, navigazione verso la pagina di catalogo
Pagina del Catalogo, visualizzazione della lista degli autori, nessuna paginazione. Reperimento della lista richiamando la risorsa authors esposta dall'api rest di web-library-be (uri: **v1/authors**).

## web-library-be
Si tratta di un progetto e modulo war deployabile su web container quali tomcat. Il progetto offre solo i servizi REST per per ottenere una collezione di risorse di tipo Author o una singola risorsa identificata tramite id.

##Build
La build è eseguibile come comando maven, da eclipse oppure da linea di comando mvn install. Nella cartella targer troverete il pacchetto war da installare su un web container (testato su Tomcat 1.8).

**Nota importante**: sfortunatamente la build del frontend non è ancora integrata con la build del backend per cui il contenuto della cartella *dist* in web-library-fe deve essere riportato manualmente nella cartella src/main/webapp.

## Funzionalità implementate
Servizio per il reperimento degli autori

##Sviluppi futuri:
L'applicazione è incompleta.
In particolare per raccogliere il requisito principale occorre aggiungere il toggle della riga al click sul bottone +.
A questa azione verrà richiesta sul servizio $http la collezione di risorse di tipo Book di un determinato autore (uri: **v1/authors/{id_author}/books**)


**Nota**: non essendo paginata e applicando un filtro angular si impone che l'applicazione abbia caricato per intero la collezione di libri di un determinato autore. Si suppone che il numero di oggetti sia limitato.

Viceversa la lista degli autori non verrà caricata per intero ma verrà caricata un numero limitato. Aggiungendo la paginazione sarà possibile passare da un set di autori ad un altro senza essere costretti a caricare l'insieme totale degli autori (uri: **v1/authors?page=1&page_size=10**). Per la costruzione della paginazione sarà necessario sarà possibile accedere all'attributo size della risorsa (uri: **v1/authors/size**)

##Estensioni
### Filtro di visualizzazione autori per intervallo di età e ricerca testuale per autore [area 2]
Sarà implementata una funzione di ricerca nella api REST che risponderà alla uri **v1/authors?from_age={from_age}&to_age={to_age}** e restituirà una lista di autori

###Ricerca per titolo con auto-completamento [area 3]
Per ipotesi tutti i libri di un autore vengono caricati all'espansione della riga dell'autore stesso. Possiamo applicare quindi un filtro angular per ricercare a runtime i libri. La ricerca potrebbe essere facilmente espansa a tutti i campi di un libro.
Sarà qualcosa di molto simile a quanto segue

    input(ng-model="title")
    ...
    tr(ng-repeater = '{books | filter:title}')

###Filtro per la ricerca di libri [area 1].

    Quando è attivo il filtro, verranno visualizzati i soli autori che contengono almeno un libro che corrisponde ai criteri selezionati.

###Ottimizzazione per dispositivi tablet (senza inficiare la fruibilità da PC)

    Per la fruibilità per dispositivi tablet è essenziale che sia ottimizzata la responsività del frontend. Una soluzione ottimale è l'utilizzo del framework bootstrap. 

Da notare che comunque il disaccoppiamento tra frontend e backend ottenuto tramite un'architettura REST abilita la costruzione di frontend dedicati ai dispositivi tablet, non ultime, nel caso di esigenze di performance particolari, applicazioni native.

###Ottimizzazione del trasferimento dati e reattività dell’interfaccia, che porti al giusto compromesso fra frequenza delle chiamate, quantità di dati trasferiti, reattività dell’interfaccia. 

    Lo scopo è ottenere una buona esperienza utente anche in presenza di connessione poco performante e allo stesso tempo un carico ragionevole per il server.

####Ottimizzazione trasferimento dati
Il trasferimento dati adottato attualmente è json. E' possibile ottenere un'ottimizzazione del dato tramite compressione dello stesso (abilitazione gzip su web server)

es su Apache .htaccess

    # compress text, html, javascript, css, xml:
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE application/json
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
    # Or, compress certain file types by extension:
    <files *.html>
    SetOutputFilter DEFLATE
    </files>

Essendo l'applicazione REST le risorse saranno facilmente cachabili.

####Ottimizzazione loading
Altre ottimizzazioni saranno fatte sul caricamento dell'applicazione
- minificazione codice js
- uso CDN per le lib js (attualmente sono unificate in un unico lib.js)

