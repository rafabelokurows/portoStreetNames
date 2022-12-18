library(stringr)
library(tidywikidatar)
library(tidyverse)
if(!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/genderBR")
library(genderBR)
tw_enable_cache()
tw_set_cache_folder(path = fs::path(fs::path_home_r(), "R", "tw_data"))
tw_set_language(language = "en")
tw_create_cache_folder(ask = FALSE)

streets <- opq(bbox = limits)  %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()
streets
available_features()
osmdata::available_tags("highway")

unique(streets$osm_lines$name) %>% sort() %>% as.data.frame() %>% 
  rename(rua=1) %>% 
  mutate(nome = case_when(str_starts(rua,"Nó ")~str_sub(rua,4),
                             str_starts(rua,"Rua |Via ")~str_sub(rua,5),
                             str_starts(rua,"Muro |Cais |Beco |Vila ")~str_sub(rua,6),
                             str_starts(rua,"Pátio |Campo |Praça |Largo |Viela |Rampa |Túnel |Ponte ")~str_sub(rua,7),
                             str_starts(rua,"Jardim |Rossio |Escada |Parque |Bairro |Quinta |Vereda ")~str_sub(rua,8),
                             str_starts(rua,"Ribeira |Recanto |Estrada |Avenida |Viaduto |Praceta |Calçada |Alameda |Rotunda |Escadas |Passeio |Ladeira |Caminho ")~str_sub(rua,9),
                             str_starts(rua,"Travessa |Ciclovia |Tribunal ")~str_sub(rua,10),
                             str_starts(rua,"Miradouro |Escadaria ")~str_sub(rua,11))
         
         ) %>% 
  mutate(teste=str_starts(nome,"^de\\s|^da\\s|^ da\\s|^do\\s"),
         clean=case_when(str_starts(nome,"^de\\s|^ da\\s|^da\\s|^do\\s")~str_sub(nome,4),
                         str_starts(nome,"^das\\s|^dos\\s")~str_sub(nome,5),
                         TRUE~nome)
         ) %>% 
  filter(!is.na(clean)) %>%
  mutate(genero =get_gender(clean)) -> ruas

ruas %>% View()
ruas2 %>% count(genero,sexoWiki)
saveRDS(ruas,"ruas.rds")
ruas2 = ruas %>%
  mutate(sexoWiki = case_when(!is.na(clean)~tw_get_label(tw_get_property(tw_search(search = clean,limit = 1)$id,p="P21")$value),
                              TRUE~NA_character_))

saveRDS(ruas2,"ruas2.rds")  
ruas2 %>% 
  mutate(sexoFinal = case_when(tolower(genero)==sexoWiki~genero,
                               !is.na(genero)& is.na(sexoWiki)~genero,
                               is.na(genero)&!is.na(sexoWiki)~stringr::str_to_title(sexoWiki))) %>% 
  clipr::write_clip()

codigos = readRDS("C:\\Users\\rafae\\Downloads\\20221205 codigos ajustados.rds")
codigos
codigos2 = readRDS("C:\\Users\\rafae\\Downloads\\20221205 1041 ruas.rds")
codigos2 %>% clipr::write_clip()

ruas2 %>% filter(!clean %in% codigos2$nome_arteria) %>% clipr::write_clip()
ruas2 %>% left_join(codigos2,by=c("clean"="nome_arteria")) %>% View()

ruas2
ruas3 = openxlsx::read.xlsx("C:\\Users\\rafae\\OneDrive\\Área de Trabalho\\ruas.xlsx",sheet = "Sheet6")
ruas3 %>% View()
ruas4 = ruas3 %>% mutate(sexoFinal2 = case_when(ajustar=="Nada"~NA_character_,
                           ajustar=="Male"~"Male",
                           ajustar=="Female"~"Female",
                           is.na(ajustar)~sexoFinal)) 

# %>% group_by(is.na(sexoFinal2)) %>% 
#   count(sexoFinal2) %>% 
#   mutate(prop=n/sum(n))

streets$osm_lines = streets$osm_lines %>% 
  left_join(ruas4 %>% select(rua,sexoFinal2),by=c("name"="rua"))


blankbg <-theme(axis.line=element_blank(),
                axis.text.x=element_blank(),
                axis.text.y=element_blank(),
                axis.ticks=element_blank(),
                axis.title.x=element_blank(),
                axis.title.y=element_blank(),
                legend.position = "none",
                plot.background=element_blank(),
                panel.grid.minor=element_blank(),
                panel.background=element_blank(),
                panel.grid.major=element_blank(),
                plot.margin = unit(c(t=1,r=1,b=1,l=1), "cm"),
                plot.caption = element_text(color = "grey20", size = 15,
                                            hjust = .5, face = "plain",
                                            family = "Didot"),
                panel.border = element_blank()
)
ggplot() +
  blankbg +
  # geom_sf(data = water,
  #         fill = alpha("#9DCAFF",1),
  #       # size = .8
  #         lwd=0#,alpha = 0.9
  #         ) +
  # geom_sf(data = railways,
  #         color = "grey30",
  #         size = .2,
  #         linetype="dotdash",
  #         alpha = 1) +
  geom_sf(data = streets$osm_lines %>%
            filter(sexoFinal2 == "Male"),
          size = .8,
          color = "limegreen") +
  geom_sf(data = streets$osm_lines %>%
            filter(sexoFinal2 == "Female"),
          size = .8,
          color = "brown1") +
  geom_sf(data = streets$osm_lines %>%
            filter(is.na(sexoFinal2)),
          size = .35,
          color = "black") +
  labs(caption = 'Porto') +
  coord_sf(xlim = city_coords[1,],
           ylim = city_coords[2,],
           expand = FALSE)