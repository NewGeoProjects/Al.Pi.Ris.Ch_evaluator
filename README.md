# Al.Pi.Ris.Ch_evaluator
software for the chemical risk evaluation
DME: Guide to Using the Code for Chemical Risk Assessment with Al.Pi.Ris.Ch
Table of Contents
1. Introduction
2. Description of the Al.Pi.Ris.Ch. Model
3. Prerequisites and Installation
4. Code Structure
5. Running the Code
6. Detailed Explanation of the Code
7. Results and Output
8. Risk Plot
9. Troubleshooting Common Issues
1. Introduction
This script assesses chemical risks related to certain substances using the Al.Pi.Ris.Ch. model. It
starts from a dataset containing substances and risk phrases (H or R) and calculates inhalation,
dermal, and cumulative risks for each substance. The script generates a CSV file with the results
and a bar chart showing the calculated risks.
2. Description of the Al.Pi.Ris.Ch. Model
The Al.Pi.Ris.Ch. model (Chemical Risk Assessment for Inhalation and Dermal Contact) is used to
estimate risks from exposure to chemical substances based on the following variables:
- Severity (M): Based on the risk phrases associated with the substances (e.g., H315, H335).
- Exposure Duration: Classified as occasional, frequent, habitual, or continuous.
- Inhalation Exposure: Depends on factors such as the daily quantity inhaled, the physical state of
the substance, volatility, type of process, and technical protections.
- Dermal Exposure: Depends on quantity, mode of contact, and exposed surface area.
The model calculates three types of risks:
- Inhalation Risk Index (IRi)
- Dermal Risk Index (IRc)
- Cumulative Risk Index (combination of IRi and IRc)
3. Prerequisites and Installation
Before running the script, ensure that the following libraries are installed in R:
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("rstudioapi")
4. Code Structure
The code is divided into several sections:
- Installation and loading of required libraries.
- Selection and loading of the input dataset.
- Risk calculation: Includes functions to calculate severity, inhalation, and dermal exposure, and the
associated risks.
- Exporting the results: The results are exported to a CSV file.
- Creating a chart: A bar chart is generated showing the inhalation, dermal, and cumulative risks for
each substance.
5. Running the Code
Step 1: Prepare the dataset
Your input dataset must have the following structure, with the risk phrases (H or R) for each
substance. Example:
Substance_Name | phrase1 | phrase2 | phrase3 | ...
Step 2: Run the script
Copy the code into your R script.
When you run the script, you will be asked to select the working directory and load the input file.
Use the dialog windows to select the folder and file. The script will then start calculating the risk for
each substance and will create a bar chart.
6. Detailed Explanation of the Code
Key Functions:
- calcola_gravita(): Assigns a severity score based on risk phrases.
- calcola_durata(): Calculates the duration of exposure.
- calcola_esposizione(): Calculates inhalation exposure based on various parameters.
- calcola_esposizione_cutanea(): Calculates dermal exposure.
- calcola_IRi(), calcola_IRc(), and calcola_rischio_cumulativo(): These functions calculate the three
main risk indices.
7. Results and Output
The script generates a CSV file named "Rischio_Calcolato_<date>.csv" containing the risk data and
input parameters used for each substance.
8. Risk Plot
The bar chart displays the risks for each substance. It is automatically generated at the end of the
script. Each substance will have three bars: one for inhalation risk, one for dermal risk, and one for
cumulative risk. A horizontal line at y=10 highlights the critical risk threshold.
9. Troubleshooting Common Issues
- Issue 1: The chart is not displayed. Make sure you are running the script in an environment that
supports chart visualization, such as RStudio.
- Issue 2: Input file error. Ensure that the input file has the correct structure.
- Issue 3: CSV is not exported. Verify that you have write permissions in the selected working
directory.
IMPORTANT DISCLAIMERS:
1) Since Al.Pi.Ris.Ch. was not designed for cancer and mutagenic risks, the risk value provided by
the program CANNOT AND SHOULD NOT BE USED FOR ANALYTICAL PURPOSES BUT
PURELY INDICATIVE OF THE PRESENCE OF A CANCER RISK.
2) This script is provided "as is" without any warranty of any kind, express or implied, including but
not limited to the warranties of merchantability or fitness for a particular purpose. Use of the
information contained in this script is at the user's own risk. We do not assume any responsibility for
direct, indirect, incidental, or consequential damages resulting from the use of this script or the
information provided. Users are responsible for ensuring that the use of chemicals and work
practices comply with local and national laws and regulations.
For info and suggestions: f.pilade@gmail.com
Methodological source: Regione Piemonte - Chemical Agent Risk Assessment

#---- ITALIAN BELOW

DME: Guida all'Uso del Codice per la Valutazione del Rischio Chimico con Al.P
Indice
1. Introduzione
2. Descrizione del Modello Al.Pi.Ris.Ch.
3. Prerequisiti e Installazione
4. Struttura del Codice
5. Esecuzione del Codice
6. Spiegazione Dettagliata del Codice
7. Risultati e Output
8. Grafico del Rischio
9. Risoluzione dei Problemi Comuni
1. Introduzione
Questo script valuta i rischi chimici legati a determinate sostanze utilizzando il modello Al.Pi.Ris.Ch..
Si parte da un dataset contenente sostanze e frasi di rischio (H o R), per arrivare al calcolo dei rischi
inalatori, cutanei e cumulativi per ogni sostanza. Lo script genera un file CSV con i risultati e un
grafico a barre con i rischi calcolati.
2. Descrizione del Modello Al.Pi.Ris.Ch.
Il modello Al.Pi.Ris.Ch. (Valutazione del rischio chimico per inalazione e contatto cutaneo) è
utilizzato per stimare i rischi derivanti dall'esposizione a sostanze chimiche in base alle seguenti
variabili:
- Gravità (M): Si basa sulle frasi di rischio associate alle sostanze (es. H315, H335).
- Durata dell'esposizione: Classificata in occasionale, frequente, abituale o continua.
- Esposizione inalatoria: Dipende da vari fattori come la quantità giornaliera inalata, lo stato fisico
della sostanza, la volatilità, il tipo di processo e le protezioni tecniche.
- Esposizione cutanea: Dipende da quantità, modalità di contatto e superficie esposta.
Il modello calcola tre tipi di rischi:
- Indice di Rischio Inalatorio (IRi)
- Indice di Rischio Cutaneo (IRc)
- Indice di Rischio Cumulativo (combinazione di IRi e IRc)
3. Prerequisiti e Installazione
Prima di eseguire lo script, assicurati di avere installato le seguenti librerie in R:
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("rstudioapi")
4. Struttura del Codice
Il codice è suddiviso in diverse sezioni:
- Installazione e caricamento delle librerie.
- Selezione e caricamento del dataset di input.
- Calcolo dei rischi: Include le funzioni per calcolare gravità, esposizione inalatoria e cutanea, e i
rischi associati.
- Esportazione dei risultati: I risultati vengono esportati in un file CSV.
- Creazione di un grafico: Viene creato un grafico a barre che mostra i rischi inalatorio, cutaneo e
cumulativo per ogni sostanza.
5. Esecuzione del Codice
Passo 1: Preparare il dataset
Il tuo dataset di input deve avere la seguente struttura, con le frasi di rischio (H o R) per ogni
sostanza. Esempio:
Nome_Sostanza | frase1 | frase2 | frase3 | ...
Passo 2: Esegui lo script
Copia il codice nel tuo script R.
Quando esegui lo script, ti verrà chiesto di selezionare la directory di lavoro e caricare il file di input.
Usa le finestre di dialogo per selezionare la cartella e il file. Lo script inizierà il calcolo del rischio per
ogni sostanza e creerà un grafico a barre.
6. Spiegazione Dettagliata del Codice
Funzioni Chiave:
- calcola_gravita(): Assegna un punteggio di gravità alle frasi di rischio.
- calcola_durata(): Calcola la durata dell'esposizione.
- calcola_esposizione(): Calcola l'esposizione inalatoria in base a vari parametri.
- calcola_esposizione_cutanea(): Calcola l'esposizione cutanea.
- calcola_IRi(), calcola_IRc() e calcola_rischio_cumulativo(): Calcolano i tre principali indici di
rischio.
7. Risultati e Output
Il codice genera un file CSV denominato "Rischio_Calcolato_<data>.csv" contenente i dati di rischio
e i parametri di input utilizzati per ciascuna sostanza.
8. Grafico del Rischio
Il grafico visualizza i rischi per ciascuna sostanza sotto forma di barre. Viene generato
automaticamente alla fine dello script. Ogni sostanza avrà tre barre: una per il rischio inalatorio, una
per il rischio cutaneo e una per il rischio cumulativo. È presente una linea orizzontale a y=10 per
evidenziare il limite di rischio critico.
9. Risoluzione dei Problemi Comuni
- Problema 1: Il grafico non viene visualizzato. Assicurati di eseguire lo script in un ambiente che
supporti la visualizzazione dei grafici.
- Problema 2: Errore di input del file. Verifica che il file di input abbia la struttura corretta.
- Problema 3: Il CSV non viene esportato. Verifica di avere i permessi di scrittura nella directory di
lavoro selezionata.
DISCLAIMER IMPORTANTI:
1) SICCOME Al.Pi.Ris.Ch. non è stato creato per il rischio cancerogeno e mutageno, il valore di
rischio fornito dal programma NON PUÒ E NON DEVE ESSERE UTILIZZATO A FINI ANALITICI
MA PURAMENTE INDICATIVI DELLA PRESENZA DI UN RISCHIO CANCEROGENO.
2) Questo script è fornito "così com'è" senza alcuna garanzia di alcun tipo, espressa o implicita,
inclusi ma non limitati a garanzie di commerciabilità o idoneità per un particolare scopo. L'uso delle
informazioni contenute in questo script è a rischio dell'utente. Non ci assumiamo alcuna
responsabilità per danni diretti, indiretti, incidentali o consequenziali derivanti dall'uso di questo
script o delle informazioni fornite. Gli utenti sono responsabili di assicurarsi che l'uso delle sostanze
chimiche e le pratiche di lavoro siano conformi alle leggi e alle normative locali e nazionali.
Per info e suggerimenti: f.pilade@gmail.com
Fonte metodologica: Regione Piemonte - Valutazione del rischio agenti chimici


