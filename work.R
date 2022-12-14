#Codigos postais
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
codigos = read.csv("C:\\Users\\belokurowsr\\OneDrive - Kantar\\Desktop\\Kantar\\Puntos Sondeo\\codigos_postais.csv",fileEncoding = "UTF8")
codigos %>% filter(desig_postal == "PORTO") %>% head(10) %>% View()
codigos %>% filter(desig_postal == "PORTO") %>% count(nome_arteria)

#Packages
library(tidyverse)
#if(!require("devtools")) install.packages("devtools")
#devtools::install_github("meirelesff/genderBR")
library(genderBR)
#install.packages("tidywikidatar")
library(tidywikidatar)
# get_gender("maria")
# get_gender("Cantor Zeca Afonso")
# map_gender("ivani") %>% View()
# get_gender("ivani",  state = "SP")
library(gt)

codigos %>% filter(desig_postal == "PORTO") %>% count(nome_arteria) %>%
  mutate(genero =get_gender(nome_arteria)) %>%
  View()
# dfteste = codigos %>% filter(desig_postal == "PORTO") %>% count(nome_arteria) %>%
#   mutate(genero =get_gender(nome_arteria)) %>% filter(is.na(genero)) %>%
#   slice(69:89)

# dfteste %>%
#   mutate(sexoWiki = tw_get_label(tw_get_property(tw_search(search = nome_arteria,limit = 1)$id,p="P21")$value))
library("tidywikidatar")
tw_enable_cache()
tw_set_cache_folder(path = fs::path(fs::path_home_r(), "R", "tw_data"))
tw_set_language(language = "en")
tw_create_cache_folder(ask = FALSE)
library(tictoc)
tic()
df2 = codigos %>% filter(desig_postal == "PORTO") %>% count(nome_arteria) %>%
  mutate(sexoCensoBR =get_gender(nome_arteria))%>%
  mutate(temnumero = parse_number(nome_arteria)) %>%
  mutate(sexoWiki = case_when(is.na(temnumero)~tw_get_label(tw_get_property(tw_search(search = nome_arteria,limit = 1)$id,p="P21")$value),
                              TRUE~NA_character_))
toc()



df2 = readRDS("codigos.rds")
#2270.11 sec elapsed
df2 %>% filter(is.na(sexoCensoBR) & !is.na(sexoWiki ))
df2  %>% filter(tolower(sexoCensoBR) != tolower(sexoWiki))
df2 %>% filter(is.na(sexoCensoBR) & is.na(sexoWiki)) %>% clipr::write_clip()
df2 %>% clipr::write_clip()
toMale = c("Aires Borges",
              "Aires de Gouveia Os?rio",
              "Almeida Valente",
              "Barbosa de Castro",
              "Barbosa Du Bocage",
              "Barros Lima",
              "Burnay",
              "C?mara Sinval",
              "Carrilho Videira",
              "Cantor Zeca Afonso",
              "Carrington da Costa",
              "Carvalho Barbosa",
              "Coelho Lousada",
              "Coelho Neto",
           "Correia de Barros",
              "Correia de S?",
              "Correia Pinto",
              "Costa Barreto",
              "Costa e Almeida",
              "Costa Mendes",
              "Deniz Jacinto",
              "Ferreira Borges",
              "Ferreira Cardoso",
              "Ferreira dos Santos",
              "Ferreira Lapa",
              "Forrester",
              "Historiador Robert Smith",
           "Leote do Rego",
           "Lob?o Vital",
           "Machado Vaz",
              "Mamede",
              "Melo Adri?o",
              "Melo Leote",
              "Moreira de Assun??o",
              "Mota Pinto",
           "Nascente da Col?nia do Doutor Manuel Laranjeira",
              "Panor?mica Edgar Cardoso",
              "Particular Borges e Irm?o",
              "Particular de Santo Isidro",
              "Particular Justino Teixeira",
              "Particular Maria Albertina",
              "Particular Meneses Russel",
              "Particular Novais da Cunha",
              "Pereira de Novais",
              "Pereira Reis",
              "Pirmin Treku",
           "Poente da Col?nia do Doutor Manuel Laranjeira",
              "Rebelo da Costa",
              "Ribeiro de Sousa",
              "Rocha Peixoto",
              "Rocha Pereira",
              "S? da Bandeira",
              "Santos Pousada",
              "S?o Cosme",
              "Saraiva de Carvalho",
              "Serpa Pinto",
              "Silva Monteiro",
              "Silva Porto",
              "Silva Ramos",
              "Silva Tapada",
              "Soares Correia",
              "Soares dos Reis",
              "Sousa ?vides",
              "Sousa J?nior",
              "Sousa Rosa",
              "Teixeira de Vasconcelos",
           "Vasques de Mesquita")
toNa = c("Aguda",
"Az?lias",
"Bessa",
"Bicalho",
"Calv?rio",
"Cima",
"Cortes",
"Dias",
"Escol?stica",
"Flores",
"Fontinha",
"Fran?a",
"Jasmins",
"Mamede",
"Mira",
"Moinhos",
"Mota Pinto",
"Pa?o",
"Pedras",
"Poeta",
"Reboleira",
"Rosmaninho",
"Agra",
"Agra de Ramalde",
"Agra do Amial",
"?gueda",
"Aldeia",
"Alegria",
"Amparo",
"Argentina",
"Arm?nia",
"Ave",
"Bela",
"Bela da Fontinha",
"Bela Vista",
"Burnay",
"Dores",
"Encarna??o",
"Escol?stica",
"Estrela e Vigorosa Sport",
"F?brica",
"F?brica \"A Invenc?vel\"",
"F?brica do Bairro da Areosa",
"F?brica Social",
"Florinha da Abrigada",
"Gl?ria",
"Graciosa",
"?ndia",
"Justa",
"Le?a",
"Liberdade",
"Li?ge",
"Nova Alf?ndega",
"Nova da Corujeira",
"Nova da Esta??o",
"Nova das Areias",
"Nova de Azevedo",
"Nova de Currais",
"Nova de S?o Crispim",
"Nova do Covelo",
"Nova do Regado",
"Nova do Rio",
"Nova do Tronco",
"Nova do Vale Formoso",
"Nova Pinheiro de Campanh?",
"Nova Sintra",
"Paiol",
"Pedra Verde",
"Preciosa",
"Sacramento",
"Sande",
"Saudade",
"Segunda",
"Vale Formoso",
"Virtudes",
"Vit?ria")
toFemale = c("Lamas")
df3 = df2 %>% mutate(sexoWiki = case_when(str_detect(nome_arteria  ,paste(toMale, collapse = "|"))~"male",
                                          str_detect(nome_arteria  ,paste(toFemale, collapse = "|"))~"female",
                                          str_detect(nome_arteria  ,paste(toNa, collapse = "|"))~NA_character_,
                                    TRUE~sexoWiki))

df3 %>% clipr::write_clip()

#total = 1768
df3 %>% filter(is.na(sexoCensoBR) & !is.na(sexoWiki )) %>% mutate(sexo=sexoWiki)#133
df3 %>% filter(!is.na(sexoCensoBR) & is.na(sexoWiki )) %>% mutate(sexo=sexoCensoBR)#480
df3 %>% filter(tolower(sexoCensoBR) == sexoWiki) %>% mutate(sexo=sexoCensoBR)#415
df3 %>% filter(tolower(sexoCensoBR) != sexoWiki) %>% mutate(sexo=sexoWiki)#3
df3 %>% filter(is.na(sexoCensoBR) & is.na(sexoWiki )) %>% mutate(sexo=NA)#727


ruascomSexo = bind_rows(df3 %>% filter(is.na(sexoCensoBR) & !is.na(sexoWiki )) %>% mutate(sexo=sexoWiki),
df3 %>% filter(!is.na(sexoCensoBR) & is.na(sexoWiki )) %>% mutate(sexo=sexoCensoBR),
df3 %>% filter(tolower(sexoCensoBR) == sexoWiki) %>% mutate(sexo=sexoCensoBR),
df3 %>% filter(tolower(sexoCensoBR) != sexoWiki) %>% mutate(sexo=sexoWiki),
df3 %>% filter(is.na(sexoCensoBR) & is.na(sexoWiki )) %>% mutate(sexo=NA)
) %>%
mutate(sexo=str_to_title(sexo))

agrupado = ruascomSexo %>% count(sexo) %>% mutate(sexo=case_when(is.na(sexo)~NA_character_,
                                                      sexo=="Female"~"Feminino",
                                                      sexo=="Male"~"Masculino")) %>%
  group_by(temsexo = !is.na(sexo)) %>%
  mutate(pct = n/sum(n)) %>%
  ungroup %>%   select(-temsexo) %>%
mutate(pct = ifelse(is.na(sexo),NA_integer_,pct))

agrupado %>% bind_rows(
agrupado %>%
  filter(!is.na(sexo)) %>% summarize(n=sum(n)) %>% mutate(sexo = "Total",pct=1) %>% relocate(sexo)) %>%
  arrange(is.na(sexo)) %>%
  gt::gt()  %>%
  gt::tab_row_group(
    label = "Nomes de pessoas",
    rows = !is.na(sexo)
  )  %>% gt::cols_label(n="N? de ruas") %>%
  # gt::summary_rows(
  #   groups = c("Nomes de pessoas"),
  #   columns = c(n,pct),
  #   fns = list(
  #     Total = ~sum(.)),
  #   formatter = gt::fmt_number,
  #   decimals = 0,
  #   use_seps = FALSE
  # )%>%
  gt::fmt_percent(pct)%>%
  # gt::tab_row_group(
  #   label = "Outros nomes",
  #   rows = is.na(sexo)
  # ) %>%
  gt::row_group_order(groups = c("Nomes de pessoas")) %>%
  gt::sub_missing(columns = sexo,missing_text = "Outros nomes") %>%
  gt::sub_missing(columns = pct,missing_text = "")
# %>%
#   tab_style(style=cell_borders(sides=c("bottom"),style="solid",weight=px(1.6)),
#             locations=gt::tab_spanner_delim(columns=everything()))


saveRDS(df2,"20221205 codigos sem ajuste.rds")
saveRDS(df3,"20221205 codigos ajustados.rds")
saveRDS(ruascomSexo,"20221205 1041 ruas.rds")
