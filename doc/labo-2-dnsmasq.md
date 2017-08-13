# Opdracht 2: Domain Name Service met BIND

## Leerdoelen

- Een DNS server met Dnsmasq kunnen opzetten en testen
    - De configuratiebestanden van Dnsmasq begrijpen
    - Een DNS-server kunnen ondervragen en testen met `dig`

## Studiemateriaal en referenties

- *Dnsmasq documentation.* Opgehaald op 2017-01-29 van <http://www.thekelleys.org.uk/dnsmasq/doc.html>
- Aitchison, R. 2015. *DNS for Rocket Scientists.* Zytrax Open. Opgehaald op 2016-03-22 van <http://www.zytrax.com/books/dns/>

## Opdrachtomschrijving

DNS is essentieel voor de correcte werking van een domein, en heel wat ([volgens sommigen *alle*](http://www.krisbuytaert.be/blog/)) netwerkproblemen zijn terug te leiden tot fouten in de configuratie van DNS. Er zijn verschillende implementaties van DNS (de meest gebruikte in de praktijk is wellicht [BIND](https://www.isc.org/downloads/bind/), maar voor ons domein, *linuxlab.lan*, zullen we gebruik maken van het eenvoudigere [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html).

In de tabel hieronder vind je een overzicht van de hosts, met hun IP adres en eventuele aliassen:

| Hostnaam | Alias | IP            | Functie                                               |
| :--      | :---  | :---          | :---                                                  |
| srv001   | ns1   | 192.168.15.2  | DNS server (Dnsmasq)                                  |
| srv002   | dhcp  | 192.168.15.3  | DHCP-server                                           |
| srv010   | www   | 192.168.15.10 | Webserver (LAMP-stack met Apache, PHP, Mariadb + CMS) |
| srv011   | file  | 192.168.15.11 | Fileserver (Samba)                                    |

- Voor alle hosts moet een "forward lookup" (van hostnaam naar IP-adres) en een "reverse lookup" (van IP-adres naar hostnaam) lukken
- Bovendien moeten ook de aliassen herkend worden.

Bedoeling is uiteraard opnieuw om heel de installatie te automatiseren aan de hand van een provisioning-script, dus alle acceptatietests (zie verder) slagen meteen na het reproduceren van de VM met "vagrant up".

## Over DNS

DNS is op zich geen complexe netwerkservice. Het komt neer op een databank met enkele tabellen die in de vorm van tekstbestanden zijn opgemaakt.

Voor dit labo maken we gebruik van Dnsmasq, een eenvoudige maar veelzijdige service die onder andere DNS ondersteunt, maar ook DHCP. Wanneer Dnsmasq draait een een query ontvangt, zal die eerst in het bestand `/etc/hosts` opzoeken of de opgegeven hostnaam erin gevonden wordt. Indien wel, zal het geassocieerde IP-adres teruggegeven worden. Zoniet zal Dnsmasq het verzoek doorgeven aan de DNS server(s) die het zelf gebruikt, opgesomd in `/etc/resolv.conf`.

### Troubleshooting

Bij het opzetten van Dnsmasq zijn volgende tips nuttig voor het opsporen van mogelijke problemen.

- Je kan de syntax van je configuratiebestanden testen voordat je de service opstart:

    ```bash
    dnsmasq --test --conf-file=/etc/dnsmasq.conf
    ```

- Je kan foutboodschappen van de service bekijken met `journalctl`. Het handigste is om een aparte console te openen, in te loggen op je server en dan het volgende commando uit te voeren:

    ```bash
    sudo journalctl -l -f -u dnsmasq.service
    ```

    Terwijl je in een andere console commando's invoert (bv. de service herstarten) zie je meteen relevante info- en foutboodschappen verschijnen.
- Zorg dat individuele queries ook gelogd worden. Kijk na hoe je dat kan instellen in `dnsmasq.conf`.
- Controleer eerst of het opzoeken van IP-adressen voor gegeven hostnamen in `/etc/hosts` correct werkt voordat je nagaat of Dnsmasq op de query kan antwoorden. Dat kan met het commando:

    ```bash
    getent ahosts HOSTNAAM
    ```

- Gebruik `nslookup` en/of `dig` op de correcte manier! Geef expliciet op welke DNS-server je ondervraagt op de command-line. `nslookup` is een eenvoudig commando, en leggen we hier niet verder uit. Lees zelf de man-page! Hieronder volgen wel enkele tips voor het gebruik van `dig`, wat een uitgebreidere tool is die meer informatie geeft over query-resultaten.

    ```bash
    dig HOST          # vraag aan de DNS-server(s) in /etc/resolv.conf
                      # het IP op voor de gegeven HOST
    dig @SERVER HOST  # vraag aan SERVER het IP op voor gegeven HOST
    dig @SERVER -x IP # vraag aan SERVER de hostnaam op voor het gegeven IP-adres
    dig @SERVER HOST +short  # Geef enkel het IP-adres terug, geen extra info
    ```

## Evaluatiecriteria

Bij het beoordelen wordt rekening gehouden met volgende aspecten:

- Alle code zit in de Github repository
- Alle acceptatietests slagen
- Het labo-verslag is aanwezig en volledig met:
    * Toelichting van de gekozen aanpak: hoe heb je de requirements gerealiseerd?
    * Testplan en -rapport: hoe toon je aan dat de specificaties, zoals hierboven omschreven, ook gerealiseerd zijn?
    * Gebruikte bronnen voor het uitwerken van de opdracht (naast deze uit de referentielijst)
- Mondeling toegelicht/demo gegeven aan de lector
