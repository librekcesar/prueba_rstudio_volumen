# Instalar y cargar las librerías necesarias Nota:la fucnión "c()" es para integrar varios objetos a un mismo vector
install.packages(c("sf", "leaflet", "dplyr"))
install.packages("RColorBrewer")

library(sf)
library(leaflet)
library(dplyr)
library(RColorBrewer)

# Cargar el GeoJSON
geojson_file <- "C:/Users/JULIO CESAR/Documents/prueba_mapa_volumen_rstudio/cdmx_v57_poligonos.geojson"
capa_geojson <- st_read(geojson_file)

# Cargar la base de datos
datos_file <- "C:/Users/JULIO CESAR/Documents/prueba_mapa_volumen_rstudio/prueba_volumen_cdmx.csv"
datos <- read.csv(datos_file)

# Combinar el GeoJSON y la base de datos por un campo común
datos_geo <- left_join(capa_geojson, datos, by = "zonificacion")

# Crear el mapa interactivo
pal <- colorFactor(palette = "viridis", domain = datos_geo$Entregados)

mapa <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%  # Selecciona el estilo del mapa base
  addPolygons(data = datos_geo, 
              fillColor = ~pal(Entregados),  # Selecciona la paleta de colores para la variable numérica
              fillOpacity = 0.7, 
              color = "white", 
              stroke = TRUE,
              weight = 1,
              label = ~paste("Nombre:", zonificacion, "<br>",
                             "Valor:", Entregados,"<br>",
                             "Total:", Total))  # Agrega etiquetas emergentes con información

# Mostrar el mapa interactivo
mapa
