# Installazione delle librerie necessarie (esegui una sola volta se non sono già installate)
# installed.packages(dplyr)
# installed.packages(ggplot2)
# installed.packages(tidyr)

# Carica le librerie richieste
library(rstudioapi)
library(dplyr)
library(ggplot2)
library(tidyr)

# Seleziona la directory di lavoro utilizzando rstudioapi
folder_directory <- rstudioapi::selectDirectory("Select Folder Directory")
setwd(folder_directory)

# Seleziona il file del dataset di input
input_filename <- rstudioapi::selectFile("Select Input Dataset", path = folder_directory)

# Leggi il dataset usando il file selezionato
df_input <- read.table(input_filename, fill = TRUE, header = TRUE)

################################################################################
# Funzione per calcolare il fattore di Gravità (M)
calcola_gravita <- function(pericolo) {
  frasi_cancerogene_mutagene <- c("H340", "H350", "H350i", "H360", "H360D", "H360F", "H361", "H361d", "H361f", "H362", 
                                  "R45", "R46", "R49", "R60", "R61")
  
  if (pericolo %in% frasi_cancerogene_mutagene) {
    return(5)  # Gravità 5 per tutti i rischi cancerogeni/mutageni
  }
  
  return(switch(pericolo,
                "H315" = 1, "H319" = 1, "H335" = 1, "H336" = 1, "H412" = 1, "H413" = 1, "H317" = 1, 
                "R22" = 1, "R36" = 1, "R38" = 1, "R66" = 1,
                "H302" = 2, "H312" = 2, "H332" = 2, "H351" = 2, "H373" = 2, "H411" = 2, "H341" = 2,
                "R21" = 2, "R37" = 2, "R41" = 2, "R67" = 2,
                "H304" = 3, "H311" = 3, "H331" = 3, "H314" = 3, "H400" = 3, "H410" = 3,
                "R23" = 3, "R24" = 3, "R42" = 3, "R43" = 3,
                "H300" = 4, "H310" = 4, "H330" = 4, "H360D" = 4, "H372" = 4, "H411" = 4,
                "R28" = 4, "R33" = 4, "R62" = 4, "R63" = 4, "R64" = 4,
                "H370" = 5, "H410" = 5, "H400" = 5,
                "R26" = 5, "R27" = 5, "R39" = 5, "R40" = 5, "R48" = 5))
}

################################################################################
# Funzioni per il calcolo del rischio inalatorio, cutaneo, e cumulativo
calcola_IRi <- function(gravita, durata, esposizione) {
  P <- durata * esposizione
  IRi <- P * gravita
  return(IRi)
}

calcola_IRc <- function(gravita, durata, esposizione_cutanea) {
  Pc <- durata * esposizione_cutanea
  IRc <- Pc * gravita
  return(IRc)
}

calcola_rischio_cumulativo <- function(IRi, IRc) {
  return(sqrt(IRi^2 + IRc^2))
}

calcola_durata <- function(percentuale_orario) {
  if (percentuale_orario < 10) {
    return(1)  # Occasionale
  } else if (percentuale_orario <= 25) {
    return(2)  # Frequente
  } else if (percentuale_orario <= 50) {
    return(3)  # Abituale
  } else {
    return(4)  # Continuo
  }
}

################################################################################
# Funzione per calcolare l'esposizione inalatoria
calcola_esposizione <- function(quantita_giornaliera, stato_fisico, volatilita, tipo_processo, protezione_tecnica) {
  Q <- ifelse(quantita_giornaliera <= 0.1, 1, 
              ifelse(quantita_giornaliera <= 1, 2, 
                     ifelse(quantita_giornaliera <= 10, 3, 
                            ifelse(quantita_giornaliera <= 100, 4, 5))))
  
  stato_fisico_corr <- switch(stato_fisico, 
                              "solido" = ifelse(volatilita == "bassa", 0, ifelse(volatilita == "media", 0.5, 1)),
                              "liquido" = ifelse(volatilita == "bassa", 0, ifelse(volatilita == "media", 0.5, 1)),
                              "gas" = 1)
  
  processo_corr <- switch(tipo_processo, 
                          "pressione" = 0.5, 
                          "energia termica" = 0.5, 
                          "energia meccanica" = 0.5,
                          0)
  
  protezione_corr <- switch(protezione_tecnica,
                            "nessuna" = 1, 
                            "ventilazione generale" = -0.5,
                            "aspirazione localizzata" = -1)
  
  esposizione_totale <- Q + stato_fisico_corr + processo_corr + protezione_corr
  return(max(min(esposizione_totale, 5), 0.5))
}

calcola_esposizione_cutanea <- function(quantita_giornaliera, modalita_contatto, superficie_esposta) {
  Q <- ifelse(quantita_giornaliera <= 0.1, 1, 
              ifelse(quantita_giornaliera <= 1, 2, 
                     ifelse(quantita_giornaliera <= 10, 3, 
                            ifelse(quantita_giornaliera <= 100, 4, 5))))
  
  contatto_corr <- switch(modalita_contatto,
                          "contatto involontario" = 1,
                          "manipolazione oggetti contaminati" = 2,
                          "dispersione manuale" = 3,
                          "dispersione meccanica" = 4,
                          "immersione" = 5)
  
  superficie_corr <- switch(superficie_esposta,
                            "piccola" = 1,
                            "mano" = 2,
                            "due mani o avambraccio" = 3,
                            "superficie maggiore" = 4)
  
  esposizione_cutanea_totale <- Q + contatto_corr + superficie_corr
  return(max(min(esposizione_cutanea_totale, 5), 0.5))
}

################################################################################

# definizione dei parametri di input!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

percentuale_durata = 30
quantita_giornaliera_inalatoria = 0.01
stato_fisico_inalatoria = "solido"
volatilita_inalatoria = "media"
tipo_processo_inalatoria = "energia meccanica"
protezione_tecnica_inalatoria = "nessuna"
quantita_giornaliera_cutanea = 0.01
modalita_contatto_cutanea = "dispersione meccanica"
superficie_esposta_cutanea = "due mani o avambraccio"


################################################################################
# Funzione per processare ogni sostanza nel dataframe e calcolare i rischi
processa_rischio <- function(df_input) {
  df_risultati <- data.frame(Nome_Sostanza = df_input$Nome_Sostanza, 
                             IRi = NA,
                             IRc = NA,
                             IR_cumulativo = NA,
                             percentuale_durata = percentuale_durata,
                             quantita_giornaliera_inalatoria = quantita_giornaliera_inalatoria,
                             stato_fisico_inalatoria = stato_fisico_inalatoria,
                             volatilita_inalatoria = volatilita_inalatoria,
                             tipo_processo_inalatoria = tipo_processo_inalatoria,
                             protezione_tecnica_inalatoria = protezione_tecnica_inalatoria,
                             quantita_giornaliera_cutanea = quantita_giornaliera_cutanea,
                             modalita_contatto_cutanea = modalita_contatto_cutanea,
                             superficie_esposta_cutanea = superficie_esposta_cutanea,
                             stringsAsFactors = FALSE)
  
  for (i in 1:nrow(df_input)) {
    frasi_HR <- df_input[i, grep("frase", colnames(df_input))]
    frasi_HR <- unlist(frasi_HR[!is.na(frasi_HR)])  
    
    if (length(frasi_HR) == 0) {
      next
    }
    
    percentuale_durata <- percentuale_durata
    quantita_giornaliera_inalatoria <- quantita_giornaliera_inalatoria
    stato_fisico_inalatoria <- stato_fisico_inalatoria 
    volatilita_inalatoria <- volatilita_inalatoria
    tipo_processo_inalatoria <- tipo_processo_inalatoria 
    protezione_tecnica_inalatoria <- protezione_tecnica_inalatoria
    quantita_giornaliera_cutanea <- quantita_giornaliera_cutanea
    modalita_contatto_cutanea <- modalita_contatto_cutanea
    superficie_esposta_cutanea <- superficie_esposta_cutanea
    
    durata <- calcola_durata(percentuale_durata)
    
    esposizione <- calcola_esposizione(
      quantita_giornaliera = quantita_giornaliera_inalatoria,
      stato_fisico = stato_fisico_inalatoria,
      volatilita = volatilita_inalatoria,
      tipo_processo = tipo_processo_inalatoria,
      protezione_tecnica = protezione_tecnica_inalatoria
    )
    
    esposizione_cutanea <- calcola_esposizione_cutanea(
      quantita_giornaliera = quantita_giornaliera_cutanea,
      modalita_contatto = modalita_contatto_cutanea,
      superficie_esposta = superficie_esposta_cutanea
    )
    
    gravita_totale <- sum(unlist(sapply(frasi_HR, function(frase) {
      val <- calcola_gravita(frase)
      return(ifelse(is.na(val), 0, val))
    })))
    
    if (is.na(gravita_totale) || gravita_totale == 0) {
      next
    }
    
    IRi <- calcola_IRi(gravita_totale, durata, esposizione)
    IRc <- calcola_IRc(gravita_totale, durata, esposizione_cutanea)
    IR_cumulativo <- calcola_rischio_cumulativo(IRi, IRc)
    
    df_risultati$IRi[i] <- IRi
    df_risultati$IRc[i] <- IRc
    df_risultati$IR_cumulativo[i] <- IR_cumulativo
  }
  
  # Esporta il dataframe come file CSV
  output_filename <- paste0("Rischio_Calcolato_", Sys.Date(), ".csv")
  write.csv(df_risultati, output_filename, row.names = FALSE)
  cat("File esportato:", output_filename, "\n")
  
  # Crea un barplot con ggplot2
  df_long <- df_risultati %>%
    pivot_longer(cols = c("IRi", "IRc", "IR_cumulativo"), 
                 names_to = "Tipo_Rischio", 
                 values_to = "Valore_Rischio")
  
  plot <- ggplot(df_long, aes(x = Nome_Sostanza, y = Valore_Rischio, fill = Tipo_Rischio)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    geom_hline(yintercept = 10, linetype = "dashed", color = "red", size = 1.2) +  # Linea orizzontale
    labs(title = "Valutazione del Rischio per Sostanza",
         x = "Nome Sostanza", y = "Valore di Rischio") +
    scale_fill_manual(values = c("IRi" = "blue", "IRc" = "green", "IR_cumulativo" = "red"))
  
  print(plot)
  
  return(df_risultati)
}

# Esegui la funzione di calcolo del rischio
df_output <- processa_rischio(df_input)
print(df_output)

