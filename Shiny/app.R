
source("library.R")
source("plotP2.R")

## Definimos la UI
organismos <- c("Human", "Mouse", "Rat")
identificadores <- c("EntrezID", "Ensembl")


ui <- dashboardPage(
  ## Definimos Header
  dashboardHeader(title = "GSApp", titleWidth = 150),
  
  ## Definimos Sidebar
  dashboardSidebar(width = 150,
                   
                   # Definimos Menus y Submenus
                   sidebarMenu(
                     menuItem(text = "Info", tabName = "info", icon = icon("fas fa-info-circle")),
                     menuItem(text = "Load Data", tabName = "upload", icon = icon("upload")),
                     menuItem(text = "ORA Analysis", icon = icon("fas fa-magnifying-glass-chart"),
                              menuSubItem(text = "Configuration", tabName = "ORA"), 
                              menuSubItem(text = "ORA-GO", tabName = "ORAgo"), 
                              menuSubItem(text = "ORA-KEGG", tabName = "ORAkegg"),
                              menuSubItem(text = "ORA-REACTOME", tabName = "ORAreactome")
                     ),
                     menuItem(text = "GSEA Analysis", icon = icon("fas fa-magnifying-glass-chart"),
                              menuSubItem(text = "Configuration", tabName = "GSEA"), 
                              menuSubItem(text = "GSEA-GO", tabName = "GSEAgo"), 
                              menuSubItem(text = "GSEA-KEGG", tabName = "GSEAkegg"),
                              menuSubItem(text = "GSEA-REACTOME", tabName = "GSEAreactome")                              
                     ),
                     menuItem(text = "PT Analysis", icon = icon("fas fa-magnifying-glass-chart"),
                              menuSubItem(text = "Configuration", tabName = "SPIA_Seleccion"),
                              menuSubItem(text = "SPIA", tabName = "SPIA")
                     ),
                     menuItem(text = "Feedback", icon = icon("github"), tags$a(href = "https://github.com/albertme0308/GSApp","GitHub repo", target="_Blank")
                     )
                   )
  ),

  ## Definimos los paneles del Body  
  dashboardBody(
    tabItems(
      
      # Definimos Panel info 
      tabItem(tabName = "info",
              fluidRow(
                box(title=HTML("<span style='color: #5197BE;'><strong>GSApp</strong></span> PATHWAY ANALYSIS"), width=12, status = "primary",
                    HTML("<p>Pathway analysis allows identifying those biological processes, such as functional characteristics, metabolic or signaling transduction pathways, that are related to the data contained in an initial list of genes. The analysis involves the following steps:</p>"),
                    HTML("<br>"),
                    HTML("<ol start='1'>"),
                    HTML("<li><strong>Annotation</strong>: Relates sets of genes that work coordinately in certain biological processes, assigning them to certain categories or terms (pathways). GSApp works with the following databases:"),
                    HTML("<ul>"),
                    HTML("<li><strong>GO</strong>: Gene Ontology organizes categories hierarchically, from the most general to the most specific, and annotations include information about biological processes, molecular functions, and cellular components.</li>"),
                    HTML("<li><strong>KEGG</strong>: Kyoto Encyclopedia of Genes and Genomes is a database that helps understand biological systems at a molecular level. It offers maps of biochemical processes that include molecular interactions, metabolic reactions, and cellular processes, among others.</li>"),
                    HTML("<li><strong>REACTOME</strong>: Reactome is an online and open-source database of biological reactions and processes that organizes interactions between molecules into categories.</li>"),
                    HTML("</ul>"),
                    HTML("</li>"),
                    HTML("<br>"),
                    HTML("<li><strong>Enrichment analysis</strong>: The most commonly used methods compare the frequency of occurrence of annotated categories in a selected list with their frequency in a reference population (background or universe). If the category appears more in the selected list, it is considered relevant to the problem under study. In GSApp, the following methods can be used:"),
                    HTML("<ul>"),
                    HTML("<li><strong>ORA</strong> (Over Representation Analysis): Evaluates the statistical over-representation of a list of genes of interest in a reference list.</li>"),
                    HTML("<li><strong>GSEA</strong> (Gene Set Enrichment Analysis): Incorporates the expression data and differential statistics of all genes to perform a statistical significance analysis test, aiming to check if genes corresponding to certain categories accumulate at the top or bottom of the ranked list by direction and magnitude of expression change.</li>"),
                    HTML("<li><strong>PT</strong> (Pathway Topology): Corresponds to state-of-the-art methods that take into account additional gene annotations related to how and where genes can interact with each other. Within this group of methods, <strong>SPIA</strong> (Signaling-Pathway Impact Analysis) stands out. This method evaluates gene expression changes, considering information on how genes interact within signaling pathways, to determine which pathways are important in a specific biological condition.</li>"),
                    HTML("</ul>"),
                    HTML("</li>"),
                    HTML("<br>"),
                    HTML("<li><strong>Visualization</strong>: Visualization will allow grouping similar processes and pathways into common functional categories. The packages used in the application include some of the most commonly used visualization methods: Upsetplot, Barplot, Dotplot, Enrichment Map, Category Netplot, Ridgeline plot, GSEA plot, Pathview, viewPath, plotP, Treeplot.</li>"),
                    HTML("</ol>"),
                    HTML("<br>"),
                    HTML("<p>In order to perform the analysis, navigate GSApp through the following menus:</p>"),
                    HTML(
                      "<table>
                          <tr>
                            <td style='text-align: right'><img src='Captura1.PNG' style='width:50%;'></td>
                            <td><b>1. Load the initial data</b></td>
                          </tr>
                          <tr>
                            <td style='text-align: right'><img src='Captura2.PNG' style='width:50%;'></td>
                            <td><b>2. Based on the method to be used, select the subset of genes to analyze and, if applicable, the reference gene list (background or universe)</b></td>
                          </tr>
                          <tr>
                            <td style='text-align: right'><img src='Captura3.PNG' style='width:50%;'></td>
                            <td><b>3. Perform the analysis according to the selected method and desired annotation</b></td>
                          </tr>
                        </table>"
                    ),
                    HTML("<br>"),
                    HTML("<p>GSApp clears all loaded data and obtained results by clicking the 'Refresh' button in the web browser.</p>")
                )
              )
      ),    
      # Definimos Panel upload
      tabItem(tabName = "upload",
              fluidRow(
                box(title = "REQUIREMENTS FOR DATA LOADING", width=12, status = "primary",
                    HTML("<p>The application allows working with gene data from three organisms: Human, Mouse, and Rat.</p>"),
                    HTML("<p>The gene identifiers can be EntrezID or Ensembl. The methods used in the application require working with EntrezID identifiers, so it will perform the conversion when necessary.</p>"), 
                    HTML("<p>The variables of interest in the loaded data must be located and named in a specific way:</p>"),
                    HTML("<ol start='1'>"),
                    HTML("<li>The first column must contain the gene identifiers.</li>"), 
                    HTML("<li>The variable that contains the identifiers must be named as EntrezID or Ensembl, as appropriate.</li>"), 
                    HTML("<li>If the list includes differential expression data, the columns with the variables of interest should be named: logFC, P.Value, and adj.P.Value.</li>"),
                    HTML("</ol>"),
                    HTML("<p>The data can be loaded from .csv, .txt, or .xlsx files. In all cases, the first row of the loaded data will correspond to the variable names (header=TRUE). In the case of the .txt file, the data separation should be a blank space. In the case of the .csv file, the data separation should be a comma. Data loading is completed when 'View gene list' button is clicked.</p>")
                )
              ),
              fluidRow(
                box(title="LOAD DATA", width=2, status = "warning",
                    selectInput("organismo", "Organism:", choices=organismos),
                    selectInput("identificador", "Gene ID:", identificadores),
                    #Si se elige ENSEMBLE crear código para transformar IDs a ENTREZ
                    selectInput("file_tipo", "Data type:", choices=c("CSV" = ".csv", "EXCEL" = ".xlsx", "TXT" = ".txt")),
                    fileInput("file_carga", label="Load gene list:",
                              accept = c(".csv", ".txt",".xlsx"),
                              buttonLabel = "Choose...",
                              placeholder = "No file selected"),
                    actionButton("ver_lista", "View gene list")
                    ),
                 box(title="TABLE WITH LOADED DATA", width=10, status = "success",
                    dataTableOutput("tabla_inicial")
                )
              )
      ),
      # Definimos Panel ORA (Selección de Genes)
      tabItem(tabName = "ORA",
              fluidRow(
                box(title = "ORA PATHWAY ANALYSIS", width=12, status = "primary",
                    HTML("<p>Over Representation Analysis (ORA) determines whether the genes corresponding to a specific category are overrepresented in a subset of our data. To perform this analysis, this method calculates the probability of having the observed proportion of genes associated with this category in our subset compared to the proportion of genes associated with the same category in the reference list ('universe').</p>"),
                    HTML("<p>ORA analysis uses the hypergeometric distribution and performs a one-tailed Fisher's exact test, obtaining different statistics for each category (p-value, adjusted p-value for multiple comparisons and q-value (false discovery rate, FDR).</p>"),
                    HTML("<p>The user must select the reference gene list ('universe'), which can be the initial loaded list or the whole genome of the selected organism.</p>"),
                    HTML("<p>Next, the user must select the list of genes on which the analysis is performed. It can be a selection of genes from the initial list (topTable) filtered based on a maximum adj.P.Val threshold and a minimum logFC threshold. By using the 'Expression' option, you can include genes with upexpression, downexpression, or both. Alternatively, the gene list can correspond to the unfiltered TopTable or an initially loaded gene list.</p>")
                )
              ),
              fluidRow(
                box(title="GENE LIST TO ANALYZE", width=4, status = "warning",
                    selectInput("universo1", "Select universe:", choices=c("Initial list", "Genome")),
                    selectInput("genes1", "Select Genes:", choices=c("Filter Toptable", "Initial Toptable", "Gene list")), 
                    conditionalPanel(
                      condition = "input.genes1 == 'Filter Toptable'",
                      sliderInput("adjpval1", "adj.P.Val max.:", value=0.05, min=0, max=1, step=0.01),
                      selectInput("regulacion1", "Expression:", choices=c("Up-regulated", "Down-regulated", "Up/Down-regulated")),
                      sliderInput("logFC1", "Log2 Fold Change min.:", value=2, min=0, max=10, step=0.1)
                    ),
                    actionButton("ver_lista_seleccionados", "See selected genes")
                ),
                box(title="TABLE WITH SELECTED GENES", width=8, status = "success",
                    dataTableOutput("tabla_seleccionada")
                )
              )
      ),   
      # Definimos Panel ORAgo
      tabItem(tabName = "ORAgo",
              h2("ORA-GO Analysis"),
              fluidRow(
                tabBox(
                  id = "ts_orago", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>The ORA-GO analysis is performed using the enrichGO() function from the clusterProfiler package. The resulting object stores the enriched GO categories in the gene subset, the observed proportion in the subset and the reference list, and the statistical values that justify the overrepresentation of these categories. GSApp allows downloading the obtained results in a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to run the ORA-GO analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>ont: GO ontologies. Options: Biological Process “BP”, Molecular Function “MF”, Cellular Component “CC” o “ALL”.</li>"),
                                 HTML("<li>pAdjustMethod: Multiple comparison adjustment method: “holm”, “hochberg”, “hommel”, “bonferroni”, “BH”, “BY”, “fdr”, “none”.</li>"),
                                 HTML("<li>minGSSize: Minimum number of genes for each gene set (category). If it is below the set threshold, that category is not reported in the results.</li>"),
                                 HTML("<li>maxGSize: Maximum number of genes for each gene set (category). If it exceeds the set threshold, that category is not reported in the results.</li>"),
                                 HTML("<li>pvalueCutoff: p-value cutoff. Only categories with a p-value below the set threshold are reported.</li>"),
                                 HTML("<li>qvalueCutoff: q-value cutoff. Only categories with a q-value below the set threshold are reported.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>If the 'Simplify GO redundancy' function is selected, the simplify() function from the clusterProfiler package is applied to reduce redundancy in the GO categories.</p>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Upsetplot: The upsetplot() function is an alternative to the Category Netplot for visualizing the complex association between genes and gene sets. This function highlights the gene overlap between different categories.</li>"),
                                 HTML("<li>Dotplot: The dotplot() function is similar to barplot(), but it can represent one more feature by the size of the dot. The color is related to the adjusted p-values from the analysis, and the dot size represents the number of genes annotated to the category. The x-axis represents the number of genes or the proportion of genes annotated to the category.</li>"),
                                 HTML("<li>Barplot: The barplot() function displays a bar plot to visualize the enriched categories. The color represents enrichment statistics (e.g., p-values), and the length of the bar represents the number of genes or the proportion of genes annotated to the category.</li>"),
                                 HTML("<li>Enrichment Map/GOplot: The enrichment map organizes the enriched categories into a network where overlapping gene sets are connected. Overlapping gene sets tend to cluster together, facilitating the identification of functional modules. To visualize enrichment maps, we have different options: the emmaplot() function, applicable to all used annotations, and the goplot() function, specific for GO annotations.</li>"),
                                 HTML("<li>Category Netplot: The cnetplot() function represents the links between genes and biological categories (e.g., GO terms or KEGG pathways) in a network form. The GSEA result is also supported, but only enriched genes in the core are shown.</li>"),
                                 HTML("<li>Tree plot: The treeplot() function performs hierarchical clustering of enriched terms using the similarity between them, calculated by default with the Jaccard similarity index. The default clustering method is ward.D, although others can be selected. By default, the number of clusters is the square root of the number of nodes.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualization, certain display options can be configured, including the number of categories to show, font size, statistical variable representing the color of nodes, and other options. In some visualizations, the obtained plots can be saved as PDF, and in all cases, by right-clicking on the plot and selecting 'Save Image As.' For further information, it is recommended to consult for the related documentation.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, an HTML, Word, or PDF report can be generated with the analysis results.</p>")
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 selectInput("ont1", "Ontology", choices=c("BP", "MF", "CC", "ALL")),
                                 selectInput("pAdjustMethod1", "pAdjust Method", choices=c("holm", "hochberg", "bonferroni", "BH", "BY", "fdr", "none")),
                                 numericInput("minGSSize1", "Min size of annotated genes", value=10, step=10, min=0),
                                 numericInput("maxGSSize1", "Max size of annotated genes", value=500, step=100, min=0, max=10000),
                                 sliderInput("pvalue1", "pvalue Cutoff", min=0, max=1, value=0.05, step=0.05),
                                 sliderInput("qvalue1", "qvalue Cutoff", min=0, max=1, value=0.2, step=0.05),
                                 checkboxInput("simplify1", "Simplify GO redundancy", value = FALSE),
                                 conditionalPanel(
                                   condition = "input.simplify1 == true",
                                   sliderInput("simplify_cutoff1", "Cutoff", value=0.7, min=0.5, max=1, step=0.1)
                                   ),
                                 #Faltaría poner readable
                                 fluidRow(
                                 actionButton("an_orago", "Analyze"),
                                 downloadButton(outputId = "download_tabla_orago", label = "Download")
                                 )
                             ),
                             box(title="TABLE ORA-GO ANALYSIS", width=10, status = "success",
                                 dataTableOutput("tabla_orago")
                             )
                           )

                  ),
                  tabPanel("Upsetplot", 
                           fluidRow(
                             box(title="Visualize Upsetplot", width=2, status = "warning",
                                 fluidRow(
                                   actionButton("ver_upsetplot1", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("upsetplot1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Dotplot", 
                           fluidRow(
                             box(title="Configure Dotplot", width=2, status = "warning",
                                 numericInput("showcat_dotplot1", "Show categories:", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_dotplot1", "Font size", min=8, max=15, value=10, step=1),
                                 fluidRow(
                                 actionButton("ver_dotplot1", label="Visualize"),
                                 downloadButton(outputId = "download_dotplot1", label = "Download")
                                 )
                                 ),
                             box(width=10, status = "success",
                               plotOutput("dotplot1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Barplot", 
                           fluidRow(
                             box(title="Configure Barplot", width=2, status = "warning",
                                 numericInput("showcat_barplot1", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_barplot1", "Font size", min=8, max=15, value=10, step=1),
                                 fluidRow(
                                   actionButton("ver_barplot1", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("barplot1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Enrichment map", 
                           fluidRow(
                             box(title="Configurar Enrichment map", width=2, status = "warning",
                                 numericInput("showcat_enmap1", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_enmap1", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 fluidRow(
                                   actionButton("ver_enmap1", label="Visualize"),
                                   downloadButton(outputId = "download_enmap1", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("enmap1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("GOplot", 
                           fluidRow(
                             box(title="Configure GO plot", width=2, status = "warning",
                                 numericInput("showcat_goplot1", "Show categories", value=5, step=5, min=5, max=100),
                                  fluidRow(
                                   actionButton("ver_goplot1", label="Visualize"),
                                   downloadButton(outputId = "download_goplot1", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("goplot1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Category Netplot", 
                           fluidRow(
                             box(title="Configure Category netplot", width=2, status = "warning",
                                 numericInput("showcat_cnetplot1", "Show categories", value=10, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_cnetplot1", label="Visualize"),
                                   downloadButton(outputId = "download_cnetplot1", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("cnetplot1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Tree plot", 
                           fluidRow(
                             box(title="Configurar Tree plot", width=2, status = "warning",
                                 numericInput("showcat_tp1", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_tp1", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 selectInput("method_tp1", "Clustering method", choices=c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")),
                                 fluidRow(
                                   actionButton("ver_tp1", label="Visualize"),
                                   downloadButton(outputId = "download_tp1", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("tp1", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the ORA-GO analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create Report", width=12, status = "warning",
                                 radioButtons("format_ORAGO", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_ORAGO") 
                             )
                           )
                  )
                )
              )
      ),
      # Definimos Panel ORAkegg
      tabItem(tabName = "ORAkegg",
              h2("ORA-KEGG Analysis"),
              fluidRow(
                tabBox(
                  id = "ts_orakegg", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>ORA-KEGG analysis is performed using the enrichKEGG() function from the clusterProfiler package. The resulting object stores the enriched KEGG categories in the gene subset, the observed proportion in the subset and reference list, and the statistical values that justify the overrepresentation of these categories. The application allows you to download the results as a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to perform the ORA-KEGG analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>pAdjustMethod: Adjustment method for multiple comparisons: 'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'fdr', 'none'.</li>"),
                                 HTML("<li>minGSSize: Minimum number of genes for each gene set (category). If it is lower than the set value, that category will not be reported in the results.</li>"),
                                 HTML("<li>maxGSize: Maximum number of genes for each gene set (category). If it exceeds the set value, that category will not be reported in the results.</li>"),
                                 HTML("<li>pvalueCutoff: p-value cutoff. Only categories with a p-value below the set value will be reported.</li>"),
                                 HTML("<li>qvalueCutoff: q-value cutoff. Only categories with a q-value below the set value will be reported.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Upsetplot: The upsetplot() function is an alternative to Category Netplot for visualizing the complex association between genes and gene sets. This function highlights the gene overlap between different categories.</li>"),
                                 HTML("<li>Dotplot: The dotplot() function is similar to barplot(), but it can represent one more feature by the size of the dot. The color is related to the adjusted p-values from the analysis, and the dot size represents the number of genes annotated to the category. The x-axis represents the number of genes or the proportion of genes annotated to the category.</li>"),
                                 HTML("<li>Barplot: The barplot() function displays a bar chart to visualize the enriched categories. The color represents enrichment statistics (e.g., p-values), and the length of the bar on the x-axis represents the number of genes or the proportion of genes annotated to the category.</li>"),
                                 HTML("<li>Enrichment Map: The enrichment map organizes the enriched categories into a network where overlapping gene sets are connected. Overlapping gene sets tend to cluster, facilitating the identification of functional modules. The emmaplot() function is used to visualize enrichment maps.</li>"),
                                 HTML("<li>Category Netplot: The cnetplot() function represents the links between genes and biological categories (e.g., GO terms or KEGG pathways) as a network. The result from GSEA is also supported, but only enriched genes in the core are shown.</li>"),
                                 HTML("<li>Pathview: The pathview() function is a tool that integrates and visualizes biological pathway data. Users only need to specify the desired pathway based on the enrichment analysis, and the application opensthe pathway with native KEGG views in the browser.</li>"),
                                 HTML("<li>Tree plot: The treeplot() function performs hierarchical clustering of enriched terms using the similarity between them, calculated by default with the Jaccard similarity index. The default clustering method is ward.D, although other methods can be specified. By default, the number of clusters is the square root of the number of nodes.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualization, certain display options can be configured, such as the number of categories to show, font size, statistical variable representing the color of the nodes, and other options. In some visualizations, the generated plots can be saved as PDF, and in all cases, by right-clicking on the plot and selecting 'Save Image As'. For further information, it is recommended to consult the related documentation.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, you can generate a report in HTML, Word, or PDF format with the analysis results.</p>")
                           )
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 selectInput("pAdjustMethod2", "pAdjust Method", choices=c("holm", "hochberg", "bonferroni", "BH", "BY", "fdr", "none")),
                                 numericInput("minGSSize2", "Min size of annotated genes", value=10, step=10, min=0),
                                 numericInput("maxGSSize2", "Mas size of annotated genes", value=500, step=100, min=0, max=10000),
                                 sliderInput("pvalue2", "pvalue Cutoff", min=0, max=1, value=0.05, step=0.05),
                                 sliderInput("qvalue2", "qvalue Cutoff", min=0, max=1, value=0.2, step=0.05),

                                 fluidRow(
                                   actionButton("an_orakegg", "Analyze"),
                                   downloadButton(outputId = "download_tabla_orakegg", label = "Download")
                                 )
                             ),
                             box(title="TABLE ORA-KEGG ANALYSIS", width=10, status = "success",
                                 dataTableOutput("tabla_orakegg")
                             )
                           )
                           
                  ),
                  tabPanel("Upsetplot", 
                           fluidRow(
                             box(title="Visualize Upsetplot", width=2, status = "warning",
                                 fluidRow(
                                   actionButton("ver_upsetplot2", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("upsetplot2", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Dotplot", 
                           fluidRow(
                             box(title="Configure Dotplot", width=2, status = "warning",
                                 numericInput("showcat_dotplot2", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_dotplot2", "Font size", min=8, max=15, value=10, step=1),
                                 fluidRow(
                                   actionButton("ver_dotplot2", label="Visualize"),
                                   downloadButton(outputId = "download_dotplot2", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("dotplot2", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Barplot", 
                           fluidRow(
                             box(title="Configurar Barplot", width=2, status = "warning",
                                 numericInput("showcat_barplot2", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_barplot2", "Font size", min=8, max=15, value=10, step=1),
                                 fluidRow(
                                   actionButton("ver_barplot2", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("barplot2", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Enrichment map", 
                           fluidRow(
                             box(title="Configurar Enrichment map", width=2, status = "warning",
                                 numericInput("showcat_enmap2", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_enmap2", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 fluidRow(
                                   actionButton("ver_enmap2", label="Visualize"),
                                   downloadButton(outputId = "download_enmap2", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("enmap2", width=800, height=675)
                             )
                           )
                  ),
                   tabPanel("Category Netplot", 
                           fluidRow(
                             box(title="Configurar Category netplot", width=2, status = "warning",
                                 numericInput("showcat_cnetplot2", "Show categories", value=10, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_cnetplot2", label="Visualize"),
                                   downloadButton(outputId = "download_cnetplot2", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("cnetplot2", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Pathway", 
                           fluidRow(
                             box(title="Seleccionar KEGG Pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("pathway_num2", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("pathway_id2"),
                                   textOutput("pathway_desc2"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_pathway2", label="Browse")
                                 )
                             ),
                             box(title="KEGG Pathway Selected",width=8, status = "success",
                                 "1. Select KEGG pathway", br(),
                                 HTML("2. By clicking <b>Browse</b> www.kegg.jp webpage will open in a new tab with the info of the selected pathway.")
                             )
                           )
                  ),
                  tabPanel("Tree plot", 
                           fluidRow(
                             box(title="Configure Tree plot", width=2, status = "warning",
                                 numericInput("showcat_tp2", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_tp2", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 selectInput("method_tp2", "Clustering method", choices=c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")),
                                 fluidRow(
                                   actionButton("ver_tp2", label="Visualize"),
                                   downloadButton(outputId = "download_tp2", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("tp2", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the ORA-KEGG analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create Report", width=12, status = "warning",
                                 radioButtons("format_ORAKEGG", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_ORAKEGG") 
                             )
                           )
                  )
                )
              )
      ),
      # Definimos Panel ORAreactome
      tabItem(tabName = "ORAreactome",
              h2("ORA-REACTOME Analysis"),
              fluidRow(
                tabBox(
                  id = "ts_orareactome", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>ORA-REACTOME analysis is performed using the enrichPathway() function from the ReactomePA package. The resulting object stores the enriched Reactome pathways in the gene subset, the observed proportion in the subset and reference list, and the statistical values that justify the overrepresentation of these categories. The application allows downloading the obtained results in a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to perform the ORA-REACTOME analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>pAdjustMethod: Adjustment method for multiple comparisons: 'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'fdr', 'none'.</li>"),
                                 HTML("<li>minGSSize: Minimum number of genes for each gene set (category). If it is lower than the set value, that category is not reported in the results.</li>"),
                                 HTML("<li>maxGSize: Maximum number of genes for each gene set (category). If it is higher than the set value, that category is not reported in the results.</li>"),
                                 HTML("<li>pvalueCutoff: p-value cutoff. Only categories with a p-value lower than the set value are reported.</li>"),
                                 HTML("<li>qvalueCutoff: q-value cutoff. Only categories with a q-value lower than the set value are reported.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Upsetplot: The upsetplot() function is an alternative to the Category Netplot for visualizing the complex association between genes and gene sets. This function highlights the overlapping of genes between different categories.</li>"),
                                 HTML("<li>Dotplot: The dotplot() function is similar to barplot(), but it can represent one more feature by the size of the dot. The color is related to the adjusted p-values of the analysis, and the size of the dot represents the number of genes annotated to the category. On the x-axis, it represents the number of genes or the proportion annotated to the category with respect to the total.</li>"),
                                 HTML("<li>Barplot: The barplot() function shows a bar chart to visualize the enriched categories. The color represents enrichment statistics (e.g., p-values), and the length of the bar represents the number of genes or the proportion annotated to the category with respect to the total on the x-axis.</li>"),
                                 HTML("<li>Enrichment Map: The enrichment map organizes the enriched categories in a network where overlapping gene sets are connected. Overlapping gene sets tend to cluster, facilitating the identification of functional modules. The emmaplot() function is used to visualize enrichment maps.</li>"),
                                 HTML("<li>Category Netplot: The cnetplot() function represents the links between genes and biological categories (e.g., GO terms or KEGG pathways) in the form of a network. The result of GSEA is also supported, but only enriched genes in the core are shown.</li>"),
                                 HTML("<li>Category Pathway: The viewPath() allows representing the network connecting genes related to a specified Reactome category.</li>"),
                                 HTML("<li>Reactome Pathway: Users only need to specify the desired pathway based on the enrichment analysis, and the application opens the pathway with the native views of the Reactome database in the browser.</li>"),
                                 HTML("<li>Tree plot: The treeplot() function performs hierarchical clustering of enriched terms using their similarity, calculated by default with the Jaccard similarity index. The default clustering method is ward.D, although others can be specified. By default, the number of clusters is the square root of the number of nodes.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualization, certain display options can be configured, including the number of categories to show, font size, statistical variable representing the color of nodes, and other options. In some visualizations, the obtained plots can be saved as PDF, and in all cases, by right-clicking on the plot and selecting 'Save Image As'. Forfurther information, it is recommended to consult the related documentation.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, a report in HTML, Word, or PDF format can be generated with the analysis results.</p>")
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 selectInput("pAdjustMethod3", "pAdjust Method", choices=c("holm", "hochberg", "bonferroni", "BH", "BY", "fdr", "none")),
                                 numericInput("minGSSize3", "Min size of annotated genes", value=10, step=10, min=0),
                                 numericInput("maxGSSize3", "Max size of annotated genes", value=500, step=100, min=0, max=10000),
                                 sliderInput("pvalue3", "pvalue Cutoff", min=0, max=1, value=0.05, step=0.05),
                                 sliderInput("qvalue3", "qvalue Cutoff", min=0, max=1, value=0.2, step=0.05),
                                 
                                 fluidRow(
                                   actionButton("an_orareactome", "Analyze"),
                                   downloadButton(outputId = "download_tabla_orareactome", label = "Download")
                                 )
                             ),
                             box(title="TABLE ORA-REACTOME ANALYSIS", width=10, status = "success",
                                 dataTableOutput("tabla_orareactome")
                             )
                           )
                           
                  ),
                  tabPanel("Upsetplot", 
                           fluidRow(
                             box(title="Visualize Upsetplot", width=2, status = "warning",
                                 fluidRow(
                                   actionButton("ver_upsetplot3", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("upsetplot3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Dotplot", 
                           fluidRow(
                             box(title="Configure Dotplot", width=2, status = "warning",
                                 numericInput("showcat_dotplot3", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_dotplot3", "Font size", min=8, max=15, value=10, step=1),
                                 fluidRow(
                                   actionButton("ver_dotplot3", label="Visualize"),
                                   downloadButton(outputId = "download_dotplot3", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("dotplot3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Barplot", 
                           fluidRow(
                             box(title="Configure Barplot", width=2, status = "warning",
                                 numericInput("showcat_barplot3", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_barplot3", "Font size", min=8, max=15, value=10, step=1),
                                 fluidRow(
                                   actionButton("ver_barplot3", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("barplot3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Enrichment map", 
                           fluidRow(
                             box(title="Configure Enrichment map", width=2, status = "warning",
                                 numericInput("showcat_enmap3", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_enmap3", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 fluidRow(
                                   actionButton("ver_enmap3", label="Visualize"),
                                   downloadButton(outputId = "download_enmap3", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("enmap3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Category Netplot", 
                           fluidRow(
                             box(title="Configure Category netplot", width=2, status = "warning",
                                 numericInput("showcat_cnetplot3", "Show categories", value=10, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_cnetplot3", label="Visualize"),
                                   downloadButton(outputId = "download_cnetplot3", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("cnetplot3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Category Pathway", 
                           fluidRow(
                             box(title="Select Reactome Pathway", width=2, status = "warning",
                                 fluidRow(
                                   numericInput("pathway_num3", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("pathway_id3"),
                                   textOutput("pathway_desc3"),
                                   ""
                                   ),
                                 fluidRow(
                                   actionButton("ver_pathway3", label="Visualize"),
                                   downloadButton(outputId = "download_pathway3", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("pathway3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Reactome Pathway", 
                           fluidRow(
                             box(title="Select REACTOME Pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("r_pathway_num3", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("r_pathway_id3"),
                                   textOutput("r_pathway_desc3"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_r_pathway3", label="Browse")
                                 )
                             ),
                             box(title="Reactome Pathway Seleccionada",width=8, status = "success",
                                 "1. Select Reactome pathway", br(),
                                 HTML("2. By clicking <b>Browse</b> reactome.org webpage will open in a new tab with the info of the selected pathway.")
                             )
                           )
                  ),
                  tabPanel("Tree plot", 
                           fluidRow(
                             box(title="Configure Tree plot", width=2, status = "warning",
                                 numericInput("showcat_tp3", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_tp3", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 selectInput("method_tp3", "Clustering method", choices=c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")),
                                 fluidRow(
                                   actionButton("ver_tp3", label="Visualize"),
                                   downloadButton(outputId = "download_tp3", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("tp3", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the ORA-REACTOME analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create Report", width=12, status = "warning",
                                 radioButtons("format_ORAREACTOME", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_ORAREACTOME") 
                             )
                           )
                  )
                )
              )
      ),
      
      # Definimos Panel GSEA (Visualización Genes)
      tabItem(tabName = "GSEA",
              fluidRow(
                box(title = "GSEA PATHWAY ANALYSIS", width=12, status = "primary",
                    HTML("<p>Unlike ORA analysis, Gene Set Enrichment Analysis (GSEA) uses all the genes from the starting list.</p>"),
                    HTML("<p>The genes are ranked based on statistical values or differential expression between the evaluated groups (P.Value or logFC), and then it is analyzed whether the annotated categories are randomly distributed throughout the gene list or are mainly found at the top or the bottom.</p>"),
                    HTML("<p>In GSEA enrichment analysis, the Enrichment Score (ES) is obtained. This calculation is associated with an estimation of significance level (p-value of ES) that is calculated using a permutation testing. As expected in these cases, adjustment for multiple comparisons is performed, correcting the p-value according to the selected method (p.adjust), and controlling the false discovery rate (q-value).</p>")
                )
              ),
              fluidRow(
                box(title="SELECTION OF THE RANKING VARIABLE", width=4, status = "warning",
                    selectInput("parametro", "Select", choices=c("logFC", "P.Value")),
                    actionButton("ver_lista_genes_gsea", "See ranked list")
                ),
                box(title="TABLE RANKED LIST", width=8, status = "success",
                    dataTableOutput("tabla_ordenada")
                )
              )
      ),   
      # Definimos Panel GSEAgo
      tabItem(tabName = "GSEAgo",
              h2("GSEA-GO ANALYSIS"),
              fluidRow(
                tabBox(
                  id = "ts_gseago", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>GSEA-GO analysis is performed using the gseGO() function from the clusterProfiler package. The resulting object stores the enriched GO categories, the count of annotated genes in them, the enrichment scores (ES/NES), and the statistical values justifying that these categories are significantly enriched. The application allows downloading the obtained results in a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to execute the GSEA-GO analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>ont: GO ontologies. Options: Biological Process 'BP', Molecular Function 'MF', Cellular Component 'CC', or 'ALL'.</li>"),
                                 HTML("<li>pAdjustMethod: Adjustment method for multiple comparisons: 'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'fdr', 'none'.</li>"),
                                 HTML("<li>minGSSize: Minimum number of genes for each gene set (category). If it is lower than the set value, that category is not reported in the results.</li>"),
                                 HTML("<li>maxGSize: Maximum number of genes for each gene set (category). If it exceeds the set value, that category is not reported in the results.</li>"),
                                 HTML("<li>pvalueCutoff: p-value cutoff. Only categories with a p-value lower than the set value are reported.</li>"),
                                 HTML("<li>eps: Lower limit for p-value calculation. It is recommended to use a value of 0.</li>"),
                                 HTML("<li>by: Method 'fgsea' or 'DOSE'.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>If the 'Simplify GO redundancy' is selected, the simplify() function from the clusterProfiler package is applied to reduce the redundancy of the GO categories obtained in the analysis.</p>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Upsetplot: The upsetplot() function is an alternative to Category Netplot for visualizing the complex association between genes and gene sets. This function highlights the gene overlap between different categories.</li>"),
                                 HTML("<li>Dotplot: The dotplot() function is similar to barplot(), but it can represent one more feature by the size of the dot. The color is related to the adjusted p-values of the analysis, and the dot size represents the number of genes annotated to the category. On the x-axis, it shows the number of genes or the proportion relative to the total annotated in the category. It is possible to separate categories based on the expression of related genes.</li>"),
                                 HTML("<li>Enrichment Map/GOplot: The enrichment map organizes the enriched categories into a network where overlapping gene sets are connected. Overlapping gene sets tend to cluster, facilitating the identification of functional modules. For visualizing enrichment maps, we have different options: the emmaplot() function, applicable to all used annotations, and the goplot() function, specific for GO annotations.</li>"),
                                 HTML("<li>Category Netplot: The cnetplot() function represents the links between genes and biological categories (e.g., GO terms or KEGG pathways) in the form of a network. The GSEA result is also supported, but only the enriched genes in the core are shown.</li>"),
                                 HTML("<li>Ridgeline plot: The ridgeplot() function visualizes the expression distributions for the categories obtained in the GSEA analysis. It helps users interpret the enriched biological pathways resulting from overexpression or underexpression of the identified gene sets.</li>"),
                                 HTML("<li>GSEA plot: The gseaplot() function allows representing the Running Enrichment score for the selected gene set in the list ordered according to the GSEA analysis.</li>"),
                                 HTML("<li>Tree plot: The treeplot() function  performs hierarchical clustering of enriched terms using similarity between them, calculated by default with the Jaccard similarity index. The default agglomeration method is ward.D, although others can be specified. By default, the number of clusters is the square root of the number of nodes.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualization, certain display options can be configured, highlighting the options for the number of categories to display, font size, statistical variable representing the color of nodes, and other options. In some visualizations, the obtained plots can be saved as PDF, and in all cases, by right-clicking on the plot and selecting 'Save Image As'. For further information, it is recommended to consult the related documentation.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, an HTML, Word, or PDF report can be generated with the analysis results.</p>")
                             ) 
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 selectInput("ont4", "Ontology", choices=c("BP", "MF", "CC", "ALL")),
                                 selectInput("pAdjustMethod4", "pAdjust Method", choices=c("holm", "hochberg", "bonferroni", "BH", "BY", "fdr", "none")),
                                 numericInput("minGSSize4", "Min size of annotated genes", value=10, step=10, min=0),
                                 numericInput("maxGSSize4", "Max size of annotated genes", value=500, step=100, min=0, max=10000),
                                 sliderInput("pvalue4", "pvalue Cutoff", min=0, max=1, value=0.05, step=0.05),
                                 sliderInput("eps4", "eps", min=0, max=1e-10, value=0),
                                 selectInput("by4", "By", choices=c("fgsea", "DOSE")),
                                 checkboxInput("simplify4", "Simplify GO redundancy", value = FALSE),
                                 conditionalPanel(
                                   condition = "input.simplify4 == true",
                                   sliderInput("simplify_cutoff4", "Cutoff:", value=0.7, min=0.5, max=1, step=0.1)
                                 ),
                                 #Faltaría poner readable
                                 fluidRow(
                                   actionButton("an_gseago", "Analyze"),
                                   downloadButton(outputId = "download_tabla_gseago", label = "Download")
                                 )
                             ),
                             box(title="TABLA ANÁLISIS GSEA GO", width=10, status = "success",
                                 dataTableOutput("tabla_gseago")
                             )
                           )
                           
                  ),
                  tabPanel("Upsetplot", 
                           fluidRow(
                             box(title="Visualize Upsetplot", width=2, status = "warning",
                                 fluidRow(
                                   actionButton("ver_upsetplot4", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("upsetplot4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Dotplot", 
                           fluidRow(
                             box(title="Configure Dotplot", width=2, status = "warning",
                                 numericInput("showcat_dotplot4", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_dotplot4", "Font size", min=8, max=15, value=10, step=1),
                                 radioButtons("expresion4", "Expression", choices=c("Global", "Differential")),
                                 fluidRow(
                                   actionButton("ver_dotplot4", label="Visualize"),
                                   downloadButton(outputId = "download_dotplot4", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("dotplot4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Enrichment map", 
                           fluidRow(
                             box(title="Configure Enrichment map", width=2, status = "warning",
                                 numericInput("showcat_enmap4", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_enmap4", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 fluidRow(
                                   actionButton("ver_enmap4", label="Visualize"),
                                   downloadButton(outputId = "download_enmap4", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("enmap4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("GOplot", 
                           fluidRow(
                             box(title="Configure GO plot", width=2, status = "warning",
                                 numericInput("showcat_goplot4", "Show categories", value=5, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_goplot4", label="Visualize"),
                                   downloadButton(outputId = "download_goplot4", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("goplot4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Category Netplot", 
                           fluidRow(
                             box(title="Configure Category netplot", width=2, status = "warning",
                                 numericInput("showcat_cnetplot4", "Show categories", value=10, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_cnetplot4", label="Visualize"),
                                   downloadButton(outputId = "download_cnetplot4", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("cnetplot4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Ridgeplot", 
                           fluidRow(
                             box(title="Configure Ridgeplot", width=2, status = "warning",
                                 numericInput("showcat_ridgeplot4", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("label_format_ridgeplot4", "Axis length", min=10, max=50, value=30, step=5),
                                 radioButtons("fill_ridgeplot4", "Variable for color", choices=c("pvalue", "p.adjust")),
                                 fluidRow(
                                   actionButton("ver_ridgeplot4", label="Visualier")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("ridgeplot4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("GSEA plot", 
                           fluidRow(
                             box(title="Select pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("gseago_num4", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("gseago_id4"),
                                   textOutput("gseago_desc4"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_gseaplot4", label="Visualize")
                                 )
                             ),
                             box(width=8, status = "success",
                                 plotOutput("gseaplot4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Tree plot", 
                           fluidRow(
                             box(title="Configure Tree plot", width=2, status = "warning",
                                 numericInput("showcat_tp4", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_tp4", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 selectInput("method_tp4", "Clustering method", choices=c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")),
                                 fluidRow(
                                   actionButton("ver_tp4", label="Visualize"),
                                   downloadButton(outputId = "download_tp4", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("tp4", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the GSEA-GO analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create report", width=12, status = "warning",
                                 radioButtons("format_GSEAGO", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_GSEAGO") 
                             )
                           )
                  )
                  
                )
              )             
      ),
      
      # Definimos Panel GSEAkegg
      tabItem(tabName = "GSEAkegg",
              h2("GSEA-KEGG Analysis"),
              fluidRow(
                tabBox(
                  id = "ts_gseakegg", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>GSEA-KEGG analysis is performed using the gseKEGG() function from the clusterProfiler package. The resulting object stores the enriched KEGG categories, the count of annotated genes in each category, the enrichment scores (ES/NES), and the statistical values justifying the significant enrichment of these categories. The application allows downloading the results in a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to execute the GSEA-KEGG analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>pAdjustMethod: Adjustment method for multiple comparisons: 'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'fdr', 'none'.</li>"),
                                 HTML("<li>minGSSize: Minimum number of genes for each gene set (category). If it is lower than the specified value, that category is not reported in the results.</li>"),
                                 HTML("<li>maxGSize: Maximum number of genes for each gene set (category). If it exceeds the specified value, that category is not reported in the results.</li>"),
                                 HTML("<li>pvalueCutoff: p-value cutoff. Only categories with a p-value lower than the specified value are reported.</li>"),
                                 HTML("<li>eps: Lower limit for p-value calculation. It is recommended to use 0 as the value.</li>"),
                                 HTML("<li>by: Method 'fgsea' or 'DOSE'.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Upsetplot: The upsetplot() function is an alternative to the Category Netplot for visualizing the complex association between genes and gene sets. This function highlights the gene overlap between different categories.</li>"),
                                 HTML("<li>Dotplot: The dotplot() function is similar to the barplot(), but it can represent one more feature by the size of the dot. The color is related to the adjusted p-values of the analysis, and the size of the dot represents the number of genes annotated to the category. The x-axis represents the number of genes or the proportion relative to the total annotated in the category. It is possible to separate categories based on the expression of related genes.</li>"),
                                 HTML("<li>Enrichment Map: The enrichment map organizes the enriched categories into a network where overlapping gene sets are connected. Overlapping gene sets tend to cluster, facilitating the identification of functional modules. The emmaplot() function is used to visualize enrichment maps.</li>"),
                                 HTML("<li>Category Netplot: The cnetplot() function represents the links between genes and biological categories (e.g., GO terms or KEGG pathways) in the form of a network. The GSEA result is also compatible, but only the enriched genes in the core are shown.</li>"),
                                 HTML("<li>Ridgeline plot: The ridgeplot() function visualizes the expression distributions for the categories obtained in the GSEA analysis. It helps users interpret the enriched biological pathways resulting from overexpression or underexpression of the identified gene sets.</li>"),
                                 HTML("<li>GSEA plot: The gseaplot() function allows representing the Running Enrichment score for the selected gene set in the ordered list according to the GSEA analysis.</li>"),
                                 HTML("<li>Pathview: The pathview() function allows integrating and visualizing biological pathway data. Users only need to specify the desired pathway based on the enrichment analysis, and the application opens the patway in the browser with the native views of KEGG.</li>"),
                                 HTML("<li>Tree plot: The treeplot() function performs hierarchical clustering of enriched terms using the similarity between them, calculated by default with the Jaccard similarity index. The default clustering method is ward.D, although other methods can be specified. By default, the number of clusters is the square root of the number of nodes.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualization, certain display options can be configured, such as the number of categories to display, font size, statistical variable representing the color of nodes, and other options. In some visualizations, the obtained plots can be saved as PDF, and in all cases, by right-clicking on the plot and selecting 'Save Image As'. For more information, it is recommended to search for the documentation associated with the used visualization function.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, a report in HTML, Word, or PDF format can be generated with the analysis results.</p>")
                             ) 
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 selectInput("pAdjustMethod5", "pAdjust Method", choices=c("holm", "hochberg", "bonferroni", "BH", "BY", "fdr", "none")),
                                 numericInput("minGSSize5", "Min size of annotated genes", value=10, step=10, min=0),
                                 numericInput("maxGSSize5", "Max size of annotated genes", value=500, step=100, min=0, max=10000),
                                 sliderInput("pvalue5", "pvalue Cutoff", min=0, max=1, value=0.05, step=0.05),
                                 sliderInput("eps5", "eps", min=0, max=1e-10, value=0),
                                 selectInput("by5", "By", choices=c("fgsea", "DOSE")),
                                 fluidRow(
                                   actionButton("an_gseakegg", "Analize"),
                                   downloadButton(outputId = "download_tabla_gseakegg", label = "Download")
                                 )
                             ),
                             box(title="TABLA GSEA-KEGG ANALYSIS", width=10, status = "success",
                                 dataTableOutput("tabla_gseakegg")
                             )
                           )
                           
                  ),
                  tabPanel("Upsetplot", 
                           fluidRow(
                             box(title="Visualize Upsetplot", width=2, status = "warning",
                                 fluidRow(
                                   actionButton("ver_upsetplot5", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("upsetplot5", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Dotplot", 
                           fluidRow(
                             box(title="Configure Dotplot", width=2, status = "warning",
                                 numericInput("showcat_dotplot5", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_dotplot5", "Font size", min=8, max=15, value=10, step=1),
                                 radioButtons("expresion5", "Expression", choices=c("Global", "Differential")),
                                 fluidRow(
                                   actionButton("ver_dotplot5", label="Visualize"),
                                   downloadButton(outputId = "download_dotplot5", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("dotplot5", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Enrichment map", 
                           fluidRow(
                             box(title="Configure Enrichment map", width=2, status = "warning",
                                 numericInput("showcat_enmap5", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_enmap5", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 fluidRow(
                                   actionButton("ver_enmap5", label="Visualize"),
                                   downloadButton(outputId = "download_enmap5", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("enmap5", width=800, height=675)
                             )
                           )
                  ),

                  tabPanel("Category Netplot", 
                           fluidRow(
                             box(title="Configure Category netplot", width=2, status = "warning",
                                 numericInput("showcat_cnetplot5", "Show categories", value=10, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_cnetplot5", label="Visualize"),
                                   downloadButton(outputId = "download_cnetplot5", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("cnetplot5", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Ridgeplot", 
                           fluidRow(
                             box(title="Configure Ridgeplot", width=2, status = "warning",
                                 numericInput("showcat_ridgeplot5", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("label_format_ridgeplot5", "Axis length", min=10, max=50, value=30, step=5),
                                 radioButtons("fill_ridgeplot5", "Variable for color", choices=c("pvalue", "p.adjust")),
                                 fluidRow(
                                   actionButton("ver_ridgeplot5", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("ridgeplot5", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("GSEA plot", 
                           fluidRow(
                             box(title="Select pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("gseakegg_num5", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("gseakegg_id5"),
                                   textOutput("gseakegg_desc5"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_gseaplot5", label="Visualize")
                                 )
                             ),
                             box(width=8, status = "success",
                                 plotOutput("gseaplot5", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Pathway", 
                           fluidRow(
                             box(title="Select KEGG Pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("pathway_num5", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("pathway_id5"),
                                   textOutput("pathway_desc5"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_pathway5", label="Browse")
                                 )
                             ),
                             box(title="KEGG Pathway Seleccionada",width=8, status = "success",
                                 "1. Select KEGG pathway", br(),
                                 HTML("2. By clicking <b>Browse</b> www.kegg.jp webpage will open in a new tab with the info of the selected pathway.")
                             )
                           )
                  ),
                  tabPanel("Tree plot", 
                           fluidRow(
                             box(title="Configure Tree plot", width=2, status = "warning",
                                 numericInput("showcat_tp5", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_tp5", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 selectInput("method_tp5", "Clustering method", choices=c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")),
                                 fluidRow(
                                   actionButton("ver_tp5", label="Visualize"),
                                   downloadButton(outputId = "download_tp5", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("tp5", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the GSEA-KEGG analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create report", width=12, status = "warning",
                                 radioButtons("format_GSEAKEGG", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_GSEAKEGG") 
                             )
                           )
                  )
                )
              )             
      ),
      # Definimos Panel GSEAreactome
      tabItem(tabName = "GSEAreactome",
              h2("GSEA-REACTOME Analysis"),
              fluidRow(
                tabBox(
                  id = "ts_gseareactome", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>GSEA-REACTOME analysis is performed using the gsePathway() function from the ReactomePA package. The resulting object stores the enriched REACTOME categories, the count of annotated genes in those categories, the enrichment score (ES/NES), and the statistical values that justify the significant enrichment of those categories. The application allows downloading the results in a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to run the GSEA-REACTOME analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>pAdjustMethod: Adjustment method for multiple comparisons: “holm”, “hochberg”, “hommel”, “bonferroni”, “BH”, “BY”, “fdr”, “none”.</li>"),
                                 HTML("<li>minGSSize: Minimum number of genes for each gene set (category). If it is below the set value, that category is not reported in the results.</li>"),
                                 HTML("<li>maxGSize: Maximum number of genes for each gene set (category). If it exceeds the set value, that category is not reported in the results.</li>"),
                                 HTML("<li>pvalueCutoff: P-value cutoff. Only categories with a p-value lower than the set value are reported.</li>"),
                                 HTML("<li>eps: Lower limit for p-value calculation. It is recommended to use a value of 0.</li>"),
                                 HTML("<li>by: Method 'fgsea' or 'DOSE'.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Upsetplot: The upsetplot() function is an alternative to the Category Netplot for visualizing the complex association between genes and gene sets. This function highlights gene overlap between different categories.</li>"),
                                 HTML("<li>Dotplot: The dotplot() function is similar to the barplot(), but it can represent an additional feature by the size of the dot. The color is related to the adjusted p-values of the analysis, and the dot size represents the number of genes annotated to the category. On the x-axis, it shows the number of genes, or proportion relative to the total, annotated to the category. It is possible to separate categories based on the expression of the related genes.</li>"),
                                 HTML("<li>Enrichment Map: The enrichment map organizes the enriched categories into a network where overlapping gene sets are connected. Overlapping gene sets tend to cluster, facilitating the identification of functional modules. The emmaplot() function is used to visualize enrichment maps.</li>"),
                                 HTML("<li>Category Netplot: The cnetplot() function represents the links between genes and biological categories as a network. The GSEA result is also supported, but only the enriched genes in the core are shown.</li>"),
                                 HTML("<li>Ridgeline plot: The ridgeplot() function visualizes the expression distributions for the categories obtained in the GSEA analysis. It helps users interpret the enriched biological pathways derived from overexpression or underexpression of the identified gene sets.</li>"),
                                 HTML("<li>GSEA plot: The gseaplot() function allows representing the Running Enrichment score for the selected gene set in the ordered list according to the GSEA analysis.</li>"),
                                 HTML("<li>Category Pathway: The viewPath() function allows representing the network connecting genes related to a specified Reactome category.</li>"),
                                 HTML("<li>Reactome Pathway: Users only need to specify the desired pathway based on the enrichment analysis, and the application opens the pathway in the browser with the native views of the Reactome database.</li>"),
                                 HTML("<li>Tree plot: The treeplot() function performs hierarchical clustering of enriched terms using the similarity between them, calculated by default with the Jaccard similarity index. The default agglomeration method is ward.D, although others can be specified. By default, the number of clusters is the square root of the number of nodes.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualizations, certain display options can be configured, including the number of categories to show, font size, statistical variable representing the color of nodes, and other options. In some visualizations, the obtained plots can be saved as PDF, and in all cases, by right-clicking on the plot and selecting 'Save Image As'. For more information, it is recommended to refer to the documentation associated with the used visualization function.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, an HTML, Word, or PDF report can be generated with the analysis results.</p>")
                             ) 
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 selectInput("pAdjustMethod6", "pAdjust Method", choices=c("holm", "hochberg", "bonferroni", "BH", "BY", "fdr", "none")),
                                 numericInput("minGSSize6", "Min size of annotated genes", value=10, step=10, min=0),
                                 numericInput("maxGSSize6", "Max size of annotated genes", value=500, step=100, min=0, max=10000),
                                 sliderInput("pvalue6", "pvalue Cutoff", min=0, max=1, value=0.05, step=0.05),
                                 sliderInput("eps6", "eps", min=0, max=1e-10, value=0),
                                 selectInput("by6", "By", choices=c("fgsea", "DOSE")),
                                 fluidRow(
                                   actionButton("an_gseareactome", "Analize"),
                                   downloadButton(outputId = "download_tabla_gseareactome", label = "Download")
                                 )
                             ),
                             box(title="TABLA GSEA-REACTOME ANALYSIS", width=10, status = "success",
                                 dataTableOutput("tabla_gseareactome")
                             )
                           )
                  ),
                  tabPanel("Upsetplot", 
                           fluidRow(
                             box(title="Visualize Upsetplot", width=2, status = "warning",
                                 fluidRow(
                                   actionButton("ver_upsetplot6", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("upsetplot6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Dotplot", 
                           fluidRow(
                             box(title="Configure Dotplot", width=2, status = "warning",
                                 numericInput("showcat_dotplot6", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("fontsize_dotplot6", "Font size", min=8, max=15, value=10, step=1),
                                 radioButtons("expresion6", "Expression", choices=c("Global", "Differential")),
                                 fluidRow(
                                   actionButton("ver_dotplot6", label="Visualize"),
                                   downloadButton(outputId = "download_dotplot6", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("dotplot6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Enrichment map", 
                           fluidRow(
                             box(title="Configure Enrichment map", width=2, status = "warning",
                                 numericInput("showcat_enmap6", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_enmap6", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 fluidRow(
                                   actionButton("ver_enmap6", label="Visualize"),
                                   downloadButton(outputId = "download_enmap6", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("enmap6", width=800, height=675)
                             )
                           )
                  ),
                  
                  tabPanel("Category Netplot", 
                           fluidRow(
                             box(title="Configure Category netplot", width=2, status = "warning",
                                 numericInput("showcat_cnetplot6", "Show categories", value=10, step=5, min=5, max=100),
                                 fluidRow(
                                   actionButton("ver_cnetplot6", label="Visualize"),
                                   downloadButton(outputId = "download_cnetplot6", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("cnetplot6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Ridgeplot", 
                           fluidRow(
                             box(title="Configure Ridgeplot", width=2, status = "warning",
                                 numericInput("showcat_ridgeplot6", "Show categories", value=10, step=5, min=5, max=100),
                                 sliderInput("label_format_ridgeplot6", "Axis length", min=10, max=50, value=30, step=5),
                                 radioButtons("fill_ridgeplot6", "Variable for color", choices=c("pvalue", "p.adjust")),
                                 fluidRow(
                                   actionButton("ver_ridgeplot6", label="Visualize")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("ridgeplot6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("GSEA plot", 
                           fluidRow(
                             box(title="Select pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("gseareactome_num6", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("gseareactome_id6"),
                                   textOutput("gseareactome_desc6"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_gseaplot6", label="Visualize")
                                 )
                             ),
                             box(width=8, status = "success",
                                 plotOutput("gseaplot6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Category Pathway", 
                           fluidRow(
                             box(title="Select Reactome Pathway", width=2, status = "warning",
                                 fluidRow(
                                   numericInput("pathway_num6", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("pathway_id6"),
                                   textOutput("pathway_desc6"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("ver_pathway6", label="Visualize"),
                                   downloadButton(outputId = "download_pathway6", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("pathway6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel("Reactome Pathway", 
                           fluidRow(
                             box(title="Select REACTOME Pathway", width=4, status = "warning",
                                 fluidRow(
                                   numericInput("r_pathway_num6", label = "Pathway", value = 1, min = 1, max=100),
                                   textOutput("r_pathway_id6"),
                                   textOutput("r_pathway_desc6"),
                                   ""
                                 ),
                                 fluidRow(
                                   actionButton("r_ver_pathway6", label="Browse")
                                 )
                             ),
                             box(title="Reactome Pathway selected",width=8, status = "success",
                                 "1. Select Reactome pathway", br(),
                                 HTML("2. By clicking <b>Browse</b> reactome.org webpage will open in a new tab with the info of the selected pathway.")
                             )
                           )
                  ),
                  tabPanel("Tree plot", 
                           fluidRow(
                             box(title="Configure Tree plot", width=2, status = "warning",
                                 numericInput("showcat_tp6", "Show categories", value=10, step=5, min=5, max=100),
                                 radioButtons("color_tp6", "Variable for color", choices=c("pvalue", "p.adjust", "qvalue")),
                                 selectInput("method_tp6", "Clustering method", choices=c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")),
                                 fluidRow(
                                   actionButton("ver_tp6", label="Visualize"),
                                   downloadButton(outputId = "download_tp6", label = "Download")
                                 )
                             ),
                             box(width=10, status = "success",
                                 plotOutput("tp6", width=800, height=675)
                             )
                           )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the GSEA-REACTOME analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create report", width=12, status = "warning",
                                 radioButtons("format_GSEAREACTOME", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_GSEAREACTOME") 
                             )
                           )
                  )
                )
              )        
      ),
      # Definimos Panel SPIA (Selección de Genes)
      tabItem(tabName = "SPIA_Seleccion",
              fluidRow(
                box(title = "PT PATHWAY ANALYSIS", width=12, status = "primary",
                    
                    HTML("<p>PT (Pathway Topology) includes in the analysis the additional information present in the annotations regarding the topology of the pathways, i.e., the interconnection between genes and their relative position in the pathway.</p>"),
                    HTML("<p>One of PT-based methods most common used is the Signaling Pathway Impact Analysis (SPIA). SPIA integrates differential expression data from the gene list to calculate perturbations within the pathway, along with information about pathway topology and gene interactions within each pathway. This allows identifying affected pathways, even if only a small number of genes within the pathway are differentially expressed.</p>"),
                    HTML("<p>The analysis requires extracting the values that define the gene expression change for the selected genes. The set of genes to evaluate can be the entire initial list or the filtered topTable based on a maximum adjusted P-value threshold and a minimum logFC threshold. By using the Expression selector, genes with upexpression, downexpression, or both can be included.</p>"),
                    HTML("<p>The analysis will assess the overrepresentation of pathways related to the selected gene set compared to a reference list. Depending on the analysis needs, the reference list can be the gene list from the platform used in the experiment (organism's genome) or the initial TopTable itself.</p>")
                )
              ),
              fluidRow(
                box(title="GENE LIST TO ANALYZE", width=4, status = "warning",
                    selectInput("referencia7", "Select universe", choices=c("Initial list", "Genome")),
                    selectInput("genes7", "Select genes", choices=c("Filter Toptable", "Initial Toptable")), 
                    conditionalPanel(
                      condition = "input.genes7 == 'Filter Toptable'",
                      sliderInput("adjpval7", "adj.P.Val max", value=0.05, min=0, max=1, step=0.01),
                      selectInput("regulacion7", "Expression", choices=c("Up-regulated", "Down-regulated", "Up/Down-regulated")),
                      sliderInput("logFC7", "Log2 Fold Change min", value=2, min=0, max=10, step=0.1)
                    ),
                    actionButton("ver_lista_seleccionados_spia", "See selected genes")
                ),
                box(title="TABLE WITH SELECTED GENES", width=8, status = "success",
                    dataTableOutput("tabla_seleccionada_spia")
                )
              )
      ),   
      # Definimos Panel SPIA
      tabItem(tabName = "SPIA",
              h2("SPIA ANALYSIS"),
              fluidRow(
                tabBox(
                  id = "ts_spia", width=12,
                  tabPanel(title=shiny::icon("info"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>SPIA analysis is performed using the spia() function from the SPIA package. The resulting object stores the enriched KEGG categories in the gene subset, the count of annotated genes in each category (pSize), the number of differentially expressed genes in each category (NDE), the total observed accumulation of perturbations in the pathway (tA), the probability of observing at least NDE genes in the pathway using a hypergeometric model (pNDE), the probability of observing perturbations in the pathway using a hypergeometric model (pPERT), the combined p-value obtained by combining pNDE and pPERT (pG), the combined p-value obtained by combining pNDE and pPERT (pGFdr and pGFWER), the direction in which the pathway is perturbed (status=activated or inhibited), and a web link to the KEGG website showing the pathway map (KEGGLINKK). The application allows downloading the results in a .csv file.</p>"),
                                 HTML("<p>In the <i class='fas fa-cog'></i> tab, the following parameters can be customized to execute the SPIA analysis:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>Bootstrap Iterations: It is the number of bootstrap iterations to be performed to estimate the statistical significance of the SPIA results. It should be greater than 100, with a recommended value of 2000. Higher numbers of iterations result in longer processing time.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>There are different tabs for each type of visualization:</p>"),
                                 HTML("<ul>"),
                                 HTML("<li>plotP: The plotP function generates a plot of the statistical significance of the obtained biological signaling pathways from the SPIA analysis. The diagonal lines in the plot represent thresholds corresponding to significance regions based on different criteria. The points displayed to the right of these thresholds correspond to significantly enriched KEGG categories. The application allows setting the threshold.</li>"),
                                 HTML("<li>Pathway SPIA: The selected KEGG pathway based on the SPIA results can be browsed with the native views from KEGG.</li>"),
                                 HTML("</ul>"),
                                 HTML("<p>In some types of visualizations, certain display options can be configured. The visualizations can be saved by right-clicking on the plot and selecting 'Save Image As'. For further information, it is recommended to consult the related documentation.</p>"),
                                 HTML("<p>In the <i class='fa-regular fa-file'></i> tab, an HTML, Word, or PDF report can be generated with the analysis results.</p>")
                             ) 
                           )
                  ),
                  tabPanel(title=shiny::icon("gear"),
                           fluidRow(
                             box(width=2, status = "warning",
                                 sliderInput("nB7", "Bootstrap iterations", min=100, max=2000, value=100, step=100),
                                 actionButton("an_spia", "Analize"),
                                 downloadButton(outputId = "download_tabla_spia", label = "Download")
                                 ),
                             box(title="TABLE SPIA ANALYSIS", width=10, status = "success",
                                 dataTableOutput("tabla_spia")
                             )
                           )
                  ),
                  tabPanel("plotP", 
                         fluidRow(
                           box(title="Configure plotP", width=4, status = "warning",
                               fluidRow(
                                 sliderInput("threshold7", "threshold:", value=0.05, min=0, max=1, step=0.05)
                               ),
                               fluidRow(
                                 actionButton("ver_plotP7", label="Visualize")
                               )
                           ),
                           box(width=8, status = "success",
                               plotOutput("plotP7", width=800, height=675)
                           )
                         )
                  ),
                  tabPanel("Pathway SPIA", 
                         fluidRow(
                           box(title="Select KEGG Pathway", width=4, status = "warning",
                               fluidRow(
                                 numericInput("pathway_num7", label = "Pathway", value = 1, min = 1, max=100),
                                 textOutput("pathway_id7"),
                                 textOutput("pathway_desc7"),
                                 ""
                               ),
                               fluidRow(
                                 actionButton("ver_pathway7", label="Browse")
                               )
                           ),
                           box(title="KEGG Pathway selected",width=8, status = "success",
                               "1. Select KEGG pathway", br(),
                               HTML("2. By clicking <b>Browse</b> www.kegg.jp webpage will open in a new tab with the info of the selected pathway.")
                           )
                         )
                  ),
                  tabPanel(title=shiny::icon("file"),
                           fluidRow(
                             box(width=12, status = "primary",
                                 HTML("<p>To generate the report for the SPIA analysis, the user needs to have run the analysis in the <i class='fas fa-cog'></i> tab and selected the configuration in the different tabs for each type of visualization.</p>"),
                                 HTML("<p>The PDF format report requires having LATEX installed; otherwise, it will not be possible to generate.</p>")
                             ),
                             box(title="Create report", width=12, status = "warning",
                                 radioButtons("format_SPIA", "Format", c('HTML', 'Word', 'PDF'), inline = TRUE),
                                 downloadButton("downloadReport_SPIA") 
                             )
                           )
                  )
              )
          )
      )
    )
  )
)

server <- function(input, output, session) {

  ## Variables relacionadas con el organismo seleccionado
  organismo_go<-reactive({
    if(input$organismo == "Human") {
      "org.Hs.eg.db"
    } else if(input$organismo == "Mouse") {
      "org.Mm.eg.db"
    } else if(input$organismo == "Rat") {
      "org.Rn.eg.db"
    }
  })
  
  organismo_kegg<-reactive({
    if(input$organismo == "Human") {
      "hsa"
    } else if(input$organismo == "Mouse") {
      "mmu"
    } else if(input$organismo == "Rat") {
      "rat"
    }
  })
  
  organismo_reactome<-reactive({
    if(input$organismo == "Human") {
      "human"
    } else if(input$organismo == "Mouse") {
      "mouse"
    } else if(input$organismo == "Rat") {
      "rat"
    }
  })
  
  
  ##FUNCIONES RELACIONADAS CON CARGA DE DATOS
  
  #Crear dataframe lista de genes al cargar
  archivo <- reactive({
    req(input$file_carga)
    switch(input$file_tipo,
           ".csv" = read.csv(input$file_carga$datapath, header = TRUE),
           ".txt" = read.table(input$file_carga$datapath, header=TRUE, sep=""),
           ".xlsx" = read.xlsx(input$file_carga$datapath, colNames=TRUE))
    })
  
  #Código para acceder al nombre del archivo cargado desde el informe RMarkdown
  nombre_archivo <- reactive({
    req(input$file_carga)
    basename(input$file_carga$name)
  })
  
  df <- eventReactive(input$ver_lista, {
    if(input$identificador == "EntrezID") {
      df_archivo <- archivo()
      names(df_archivo)[1] <- "EntrezID"
      return(df_archivo)
    } else if(input$identificador == "Ensembl") {
      df_ensembl <- archivo()
      df_entrez1 <- bitr(df_ensembl[,1], fromType="ENSEMBL", toType="ENTREZID", OrgDb=organismo_go(), drop = FALSE)
      df_merged_entrez1 <- merge(df_ensembl, df_entrez1, by.x = "Ensembl", by.y = "ENSEMBL", all.x = TRUE)
      df_new_entrez1 <- cbind(df_merged_entrez1$ENTREZID, subset(df_merged_entrez1, select=-ENTREZID))
      colnames(df_new_entrez1)[1] <- "EntrezID"
      return(df_new_entrez1)
    }
  })
  
  output$tabla_inicial <- renderDataTable({
    req(input$file_carga)
    df()
  },options = list(pageLength = 10))
  

  ##Análisis ORA
  
  #Se define genes seleccionados para el análisis
  genes <- reactive({
    req(input$genes1)
    if (input$genes1 == "Gene list") {
      gene_list <- df()$EntrezID
      names(gene_list)<-as.character(df()$EntrezID)
      gene_list<-na.omit(gene_list)
      gene_list <- gene_list[which(duplicated(names(gene_list)) == F)]
      return(gene_list)
    } else if (input$genes1 == "Initial Toptable") {
      gene_list <- df()$logFC
      names(gene_list)<-as.character(df()$EntrezID)
      gene_list<-na.omit(gene_list)
      gene_list <- gene_list[which(duplicated(names(gene_list)) == F)]
      return(gene_list)
    } else if (input$genes1 == "Filter Toptable"){
      if (input$regulacion1 == "Up-regulated") {
        sig_genes_df = subset(df(), adj.P.Val < as.numeric(input$adjpval1)) 
        ora_list <- sig_genes_df$logFC
        names(ora_list) <- sig_genes_df$EntrezID
        ora_list <- na.omit(ora_list)
        ora_list <- ora_list[which(duplicated(names(ora_list)) == F)]
        gene_list <- ora_list[ora_list > input$logFC1] 
        return(gene_list)
      } else if (input$regulacion1 == "Down-regulated"){
        sig_genes_df = subset(df(), adj.P.Val < as.numeric(input$adjpval1)) 
        ora_list <- sig_genes_df$logFC
        names(ora_list) <- sig_genes_df$EntrezID
        ora_list <- na.omit(ora_list)
        ora_list <- ora_list[which(duplicated(names(ora_list)) == F)]
        gene_list <- ora_list[ora_list < -(input$logFC1)] 
        return(gene_list)
      } else if (input$regulacion1 == "Up/Down-regulated") {
        sig_genes_df = subset(df(), adj.P.Val < as.numeric(input$adjpval1)) 
        ora_list <- sig_genes_df$logFC
        names(ora_list) <- sig_genes_df$EntrezID
        ora_list <- na.omit(ora_list)
        ora_list <- ora_list[which(duplicated(names(ora_list)) == F)]
        gene_list <- ora_list[abs(ora_list) > input$logFC1] 
        return(gene_list)
      }
    }
  })
  
  #Se define universo de genes
  universe <- reactive({
    req(input$universo1)
    if (input$universo1 == "Initial list") {
      universe_list<-as.character(df()$EntrezID)
      universe_list<-na.omit(universe_list)
      universe_list <- universe_list[which(duplicated(universe_list) == F)]
      return(universe_list)
    } else if (input$universo1 == "Genome"){
      if (input$organismo == "Mouse") { 
        library(org.Mm.eg.db)
        universe_list<-select(org.Mm.eg.db, keys=keys(org.Mm.eg.db), columns="ENTREZID")
        universe_list <- as.character(universe_list$ENTREZID)
        return(universe_list)
      } else if (input$organismo == "Human"){
        library(org.Hs.eg.db)
        universe_list<-select(org.Hs.eg.db, keys=keys(org.Hs.eg.db), columns="ENTREZID")
        universe_list <- as.character(universe_list$ENTREZID)
        return(universe_list)
      } else if (input$organismo == "Rat"){ 
        library(org.Rn.eg.db)
        universe_list<-select(org.Rn.eg.db, keys=keys(org.Rn.eg.db), columns="ENTREZID")
        universe_list <- as.character(universe_list$ENTREZID)
        return(universe_list)
      }
    }
  })
  
  #Visualizar en tabla Lista de genes seleccionados ORA
  observeEvent(input$ver_lista_seleccionados, {
    output$tabla_seleccionada <- renderDataTable({
    req(input$file_carga)
    genes_list <- names(genes())
    if (!is.null(genes_list)) {
      genes_df <- data.frame(Genes=genes_list)
      return(genes_df)
    }
  },options = list(pageLength = 10))
  })
  
  ##Análisis ORA-GO

  #Se realiza análisis ORA-Go
  ora_go <- eventReactive(input$an_orago, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    if (input$simplify1==FALSE){
    ora_go<- enrichGO(gene=names(genes()), 
             universe = universe(), 
             OrgDb=organismo_go(),
             keyType="ENTREZID",
             ont= input$ont1,
             minGSSize=input$minGSSize1,
             maxGSSize=input$maxGSSize1,
             pAdjustMethod = input$pAdjustMethod1,
             pvalueCutoff  =as.numeric(input$pvalue1),
             qvalueCutoff  = as.numeric(input$qvalue1))
    }else if (input$simplify1==TRUE){
      ora_go<- enrichGO(gene=names(genes()), 
                        universe = universe(), 
                        OrgDb=organismo_go(),
                        keyType="ENTREZID",
                        ont= input$ont1,
                        minGSSize=input$minGSSize1,
                        maxGSSize=input$maxGSSize1,
                        pAdjustMethod = input$pAdjustMethod1,
                        pvalueCutoff  =as.numeric(input$pvalue1),
                        qvalueCutoff  = as.numeric(input$qvalue1))
      ora_go <- simplify(ora_go, cutoff=input$simplify_cutoff1, by="p.adjust", select_fun=min)
    }
    })
  
  orago_results <- reactive({
    if (!is.null(ora_go())) {
      orago_results <- data.frame(ora_go())
    } else {NULL}
  })
  
  output$tabla_orago <- renderDataTable({
      req(input$an_orago)
      orago_results()[,1:7]
      }, options = list(pageLength = 10))
  
  output$download_tabla_orago <- downloadHandler(
    filename = paste("ORA_GO_results.csv"),
    content = function(file) {
      write.csv(orago_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_upsetplot1, {
    output$upsetplot1 <- renderPlot({
      req(input$an_orago)
      upsetplot(ora_go())
    })
  })
  
  observeEvent(input$ver_dotplot1, {
    output$dotplot1 <- renderPlot({
      req(input$an_orago)
      dotplot(ora_go(), showCategory = input$showcat_dotplot1, font.size=input$fontsize_dotplot1 )
      })
    })
  
  output$download_dotplot1 <- downloadHandler(
    filename = "ORA_GO_dotplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::dotplot(ora_go(), showCategory = input$showcat_dotplot1, font.size=input$fontsize_dotplot1 ))
    }
  )
  
  observeEvent(input$ver_barplot1, {
    output$barplot1 <- renderPlot({
      req(input$an_orago)
      barplot(ora_go(), showCategory = input$showcat_barplot1, font.size=input$fontsize_barplot1 )
    })
  })
  
  ora_go_sim1 <- reactive({
    req(input$ver_enmap1)
    pairwise_termsim(ora_go())
                     })
  
  observeEvent(input$ver_enmap1, {
    output$enmap1 <- renderPlot({
      req(input$an_orago)
      emapplot(ora_go_sim1(), showCategory = input$showcat_enmap1, color=input$color_enmap1, cluster.params=list(cluster=TRUE, legend=TRUE))
    })
  })
  
  output$download_enmap1 <- downloadHandler(
    filename = "ORA_GO_enmap.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::emapplot(ora_go_sim1(), showCategory = input$showcat_enmap1, color=input$color_enmap1, cluster.params=list(cluster=TRUE, legend=TRUE)))
    }
  )

  observeEvent(input$ver_goplot1, {
    output$goplot1 <- renderPlot({
      req(input$an_orago)
      goplot(ora_go(), showCategory = input$showcat_goplot1)
    })
  })
  
  output$download_goplot1 <- downloadHandler(
    filename = "ORA_GO_goplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::goplot(ora_go(), showCategory = input$showcat_goplot1))
    }
  )

  observeEvent(input$ver_cnetplot1, {
    output$cnetplot1 <- renderPlot({
      req(input$an_orago)
      cnetplot(ora_go(), showCategory = input$showcat_cnetplot1, color.params =list(foldChange =genes()))
    })
  })
  
  output$download_cnetplot1 <- downloadHandler(
    filename = "ORA_GO_cnetplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::cnetplot(ora_go(), showCategory = input$showcat_cnetplot1, color.params =list(foldChange =genes())))
    }
  )
  
  ora_go_sim_tp1 <- reactive({
    req(input$ver_tp1)
    pairwise_termsim(ora_go())
  })
  
  observeEvent(input$ver_tp1, {
    output$tp1 <- renderPlot({
      req(input$an_orago)
      treeplot(ora_go_sim_tp1(), showCategory = input$showcat_tp1, color=input$color_tp1, cluster.params=list(method=input$method_tp1))
    })
  })
  
  output$download_tp1 <- downloadHandler(
    filename = "ORA_GO_tp.pdf",
    content = function(file) {
      ggsave(file, enrichplot:: treeplot(ora_go_sim_tp1(), showCategory = input$showcat_tp1, color=input$color_tp1, cluster.params=list(method=input$method_tp1)))
    }
  )

  ##Análisis ORA-KEGG
  
  #Se realiza análisis ORA-KEGG
  ora_kegg <- eventReactive(input$an_orakegg, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    ora_kegg<- enrichKEGG(gene=names(genes()), 
                        universe = universe(), 
                        organism = organismo_kegg(),
                        keyType="ncbi-geneid",
                        minGSSize=input$minGSSize2,
                        maxGSSize=input$maxGSSize2,
                        pAdjustMethod = input$pAdjustMethod2,
                        pvalueCutoff  =as.numeric(input$pvalue2),
                        qvalueCutoff  = as.numeric(input$qvalue2))
  })
  
  orakegg_results <- reactive({
    if (!is.null(ora_kegg())) {
      orakegg_results <- data.frame(ora_kegg())
    } else {NULL}
  })
  
  output$tabla_orakegg <- renderDataTable({
    req(input$an_orakegg)
    orakegg_results()[,1:7]
  }, options = list(pageLength = 10))
  
  output$download_tabla_orakegg <- downloadHandler(
    filename = paste("ORA_KEGG_results.csv"),
    content = function(file) {
      write.csv(orakegg_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_upsetplot2, {
    output$upsetplot2 <- renderPlot({
      req(input$an_orakegg)
      upsetplot(ora_kegg())
    })
  })
  
  observeEvent(input$ver_dotplot2, {
    output$dotplot2 <- renderPlot({
      req(input$an_orakegg)
      dotplot(ora_kegg(), showCategory = input$showcat_dotplot2, font.size=input$fontsize_dotplot2)
    })
  })
  
  output$download_dotplot2 <- downloadHandler(
    filename = "ORA_KEGG_dotplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::dotplot(ora_kegg(), showCategory = input$showcat_dotplot2, font.size=input$fontsize_dotplot2))
    }
  )
  
  observeEvent(input$ver_barplot2, {
    output$barplot2 <- renderPlot({
      req(input$an_orakegg)
      barplot(ora_kegg(), showCategory = input$showcat_barplot2, font.size=input$fontsize_barplot2)
    })
  })
  
  ora_kegg_sim2 <- reactive({
    req(input$ver_enmap2)
    pairwise_termsim(ora_kegg())
  })
  
  observeEvent(input$ver_enmap2, {
    output$enmap2 <- renderPlot({
      req(input$an_orakegg)
      emapplot(ora_kegg_sim2(), showCategory = input$showcat_enmap2, color=input$color_enmap2, cluster.params=list(cluster=TRUE, legend=TRUE))
    })
  })
  
  output$download_enmap2 <- downloadHandler(
    filename = "ORA_KEGG_enmap.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::emapplot(ora_kegg_sim2(), showCategory = input$showcat_enmap2, color=input$color_enmap2, cluster.params=list(cluster=TRUE, legend=TRUE)))
    }
  )
  
  observeEvent(input$ver_cnetplot2, {
    output$cnetplot2 <- renderPlot({
      req(input$an_orakegg)
      cnetplot(ora_kegg(), showCategory = input$showcat_cnetplot2, color.params =list(foldChange =genes()))
    })
  })
  
  output$download_cnetplot2 <- downloadHandler(
    filename = "ORA_KEGG_cnetplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::cnetplot(ora_kegg(), showCategory = input$showcat_cnetplot2, color.params =list(foldChange =genes())))
    }
  )  

  observe({
    pathway_id2 <- ora_kegg()@result$ID[input$pathway_num2]
    output$pathway_id2 <- renderText(paste("ID: ", pathway_id2))
  })
  
  observe({
    pathway_desc2 <- ora_kegg()@result$Description[input$pathway_num2]
    output$pathway_desc2 <- renderText(paste("Pathway: ", pathway_desc2))
  })
  
  observeEvent(input$ver_pathway2, {
    url <- paste0("http://www.kegg.jp/kegg-bin/show_pathway?", ora_kegg()@result$ID[input$pathway_num2])
    browseURL(url)
  })
  
  ora_kegg_sim_tp2 <- reactive({
    req(input$ver_tp2)
    pairwise_termsim(ora_kegg())
  })
  
  observeEvent(input$ver_tp2, {
    output$tp2 <- renderPlot({
      req(input$an_orakegg)
      treeplot(ora_kegg_sim_tp2(), showCategory = input$showcat_tp2, color=input$color_tp2, cluster.params=list(method=input$method_tp2))
    })
  })
  
  output$download_tp2 <- downloadHandler(
    filename = "ORA_KEGG_tp.pdf",
    content = function(file) {
      ggsave(file, enrichplot:: treeplot(ora_kegg_sim_tp2(), showCategory = input$showcat_tp2, color=input$color_tp2, cluster.params=list(method=input$method_tp2)))
    }
  )

  ##Análisis ORA-REACTOME
  
  #Se realiza análisis ORA-REACTOME
  ora_reactome <- eventReactive(input$an_orareactome, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    ora_reactome<- enrichPathway(gene=names(genes()), 
                          universe = universe(), 
                          organism = organismo_reactome(),
                          minGSSize=input$minGSSize3,
                          maxGSSize=input$maxGSSize3,
                          pAdjustMethod = input$pAdjustMethod3,
                          pvalueCutoff  =as.numeric(input$pvalue3),
                          qvalueCutoff  = as.numeric(input$qvalue3))
  })
  
  orareactome_results <- reactive({
    if (!is.null(ora_reactome())) {
      orareactome_results <- data.frame(ora_reactome())
    } else {NULL}
  })
  
  output$tabla_orareactome <- renderDataTable({
    req(input$an_orareactome)
    orareactome_results()[,1:7]
  }, options = list(pageLength = 10))
  
  output$download_tabla_orareactome <- downloadHandler(
    filename = paste("ORA_REACTOME_results.csv"),
    content = function(file) {
      write.csv(orareactome_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_upsetplot3, {
    output$upsetplot3 <- renderPlot({
      req(input$an_orareactome)
      upsetplot(ora_reactome())
    })
  })
  
  observeEvent(input$ver_dotplot3, {
    output$dotplot3 <- renderPlot({
      req(input$an_orareactome)
      dotplot(ora_reactome(), showCategory = input$showcat_dotplot3, font.size=input$fontsize_dotplot3)
    })
  })
  
  output$download_dotplot3 <- downloadHandler(
    filename = "ORA_REACTOME_dotplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::dotplot(ora_reactome(), showCategory = input$showcat_dotplot3, font.size=input$fontsize_dotplot3))
    }
  )
  
  observeEvent(input$ver_barplot3, {
    output$barplot3 <- renderPlot({
      req(input$an_orareactome)
      barplot(ora_reactome(), showCategory = input$showcat_barplot3, font.size=input$fontsize_barplot3)
    })
  })
  
  ora_reactome_sim3 <- reactive({
    req(input$ver_enmap3)
    pairwise_termsim(ora_reactome())
  })
  
  observeEvent(input$ver_enmap3, {
    output$enmap3 <- renderPlot({
      req(input$an_orareactome)
      emapplot(ora_reactome_sim3(), showCategory = input$showcat_enmap3, color=input$color_enmap3, cluster.params=list(cluster=TRUE, legend=TRUE))
    })
  })
  
  output$download_enmap3 <- downloadHandler(
    filename = "ORA_REACTOME_enmap.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::emapplot(ora_reactome_sim3(), showCategory = input$showcat_enmap3, color=input$color_enmap3, cluster.params=list(cluster=TRUE, legend=TRUE)))
    }
  )
  
  observeEvent(input$ver_cnetplot3, {
    output$cnetplot3 <- renderPlot({
      req(input$an_orareactome)
      cnetplot(ora_reactome(), showCategory = input$showcat_cnetplot3, color.params =list(foldChange =genes()))
    })
  })
  
  output$download_cnetplot3 <- downloadHandler(
    filename = "ORA_REACTOME_cnetplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::cnetplot(ora_reactome(), showCategory = input$showcat_cnetplot3, color.params =list(foldChange =genes())))
    }
  )  
  
  observe({
    pathway_id3 <- ora_reactome()@result$ID[input$pathway_num3]
    output$pathway_id3 <- renderText(paste("ID: ", pathway_id3))
  })
  
  observe({
    pathway_desc3 <- ora_reactome()@result$Description[input$pathway_num3]
    output$pathway_desc3 <- renderText(paste("Pathway: ", pathway_desc3))
  })
  
  observeEvent(input$ver_pathway3, {
    output$pathway3 <- renderPlot({
      req(input$an_orareactome)
      viewPathway(ora_reactome()@result$Description[input$pathway_num3], readable=TRUE)
    })
  })
  
  output$download_pathway3 <- downloadHandler(
    filename = "ORA_REACTOME_pathway.pdf",
    content = function(file) {
      ggsave(file, ReactomePA::viewPathway(ora_reactome()@result$Description[input$pathway_num3], readable=TRUE))
    }
  )  
  
  observe({
    r_pathway_id3 <- ora_reactome()@result$ID[input$r_pathway_num3]
    output$r_pathway_id3 <- renderText(paste("ID: ", r_pathway_id3))
  })
  
  observe({
    r_pathway_desc3 <- ora_reactome()@result$Description[input$r_pathway_num3]
    output$r_pathway_desc3 <- renderText(paste("Pathway: ", r_pathway_desc3))
  })
  
  observeEvent(input$ver_r_pathway3, {
    url <- paste0("https://reactome.org/PathwayBrowser/#/", ora_reactome()@result$ID[input$r_pathway_num3])
    browseURL(url)
  })
  
  ora_reactome_sim_tp3 <- reactive({
    req(input$ver_tp3)
    pairwise_termsim(ora_reactome())
  })
  
  observeEvent(input$ver_tp3, {
    output$tp3 <- renderPlot({
      req(input$an_orareactome)
      treeplot(ora_reactome_sim_tp3(), showCategory = input$showcat_tp3, color=input$color_tp3, cluster.params=list(method=input$method_tp3))
    })
  })
  
  output$download_tp3 <- downloadHandler(
    filename = "ORA_REACTOME_tp.pdf",
    content = function(file) {
      ggsave(file, enrichplot:: treeplot(ora_kegg_sim_tp3(), showCategory = input$showcat_tp3, color=input$color_tp3, cluster.params=list(method=input$method_tp3)))
    }
  )

  ##Análisis GSEA
  
  #Se define tabla de genes ordenada
  genes_gsea <- reactive({
    req(input$parametro)
    if (input$parametro == "logFC") {
      original_gene_list <- df()$logFC
      names(original_gene_list) <- df()$EntrezID
      gsea_list<-na.omit(original_gene_list)
      gsea_list <- gsea_list[which(duplicated(names(gsea_list)) == F)]
      gsea_list = sort(gsea_list, decreasing = TRUE)
      return(gsea_list)
    } else if (input$parametro == "P.Value") {
      original_gene_list <- df()$P.Value
      names(original_gene_list) <- df()$EntrezID
      gsea_list<-na.omit(original_gene_list)
      gsea_list <- gsea_list[which(duplicated(names(gsea_list)) == F)]
      gsea_list = sort(gsea_list, decreasing = TRUE)
      return(gsea_list)
    } 
  })
  
  #Visualizar en tabla Lista de genes ordenada GSEA
  observeEvent(input$ver_lista_genes_gsea, {
    output$tabla_ordenada <- renderDataTable({
      req(input$file_carga)
      genes_list_gsea <- cbind(names(genes_gsea()),genes_gsea())
      colnames(genes_list_gsea)=c("Genes", input$parametro)
      row.names(genes_list_gsea) <- NULL
      if (!is.null(genes_list_gsea)) {
        genes_df_gsea <- data.frame(genes_list_gsea)
        return(genes_df_gsea)
      }
    },options = list(pageLength = 10))
  })
  
  ##Análisis GSEA-GO
  
  #Se realiza análisis GSEA-Go
  gsea_go <- eventReactive(input$an_gseago, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    if (input$simplify4==FALSE){
      gsea_go<- gseGO(geneList=genes_gsea(), 
                        OrgDb=organismo_go(),
                        keyType="ENTREZID",
                        ont= input$ont4,
                        minGSSize=input$minGSSize4,
                        maxGSSize=input$maxGSSize4,
                        pAdjustMethod = input$pAdjustMethod4,
                        pvalueCutoff  =as.numeric(input$pvalue4),
                        eps  = as.numeric(input$eps4),
                        by= input$by4
                      )
    }else if (input$simplify4==TRUE){
      gsea_go<- gseGO(geneList=genes_gsea(), 
                      OrgDb=organismo_go(),
                      keyType="ENTREZID",
                      ont= input$ont4,
                      minGSSize=input$minGSSize4,
                      maxGSSize=input$maxGSSize4,
                      pAdjustMethod = input$pAdjustMethod4,
                      pvalueCutoff  =as.numeric(input$pvalue4),
                      eps  = as.numeric(input$eps4),
                      by= input$by4
                      )
      gsea_go <- simplify(gsea_go, cutoff=input$simplify_cutoff4, by="p.adjust", select_fun=min)
    }
  })
  
  gseago_results <- reactive({
    if (!is.null(gsea_go())) {
      gseago_results <- data.frame(gsea_go())
    } else {NULL}
  })
  
  output$tabla_gseago <- renderDataTable({
    req(input$an_gseago)
    gseago_results()[,1:7]
  }, options = list(pageLength = 10))
  
  output$download_tabla_gseago <- downloadHandler(
    filename = paste("GSEA_GO_results.csv"),
    content = function(file) {
      write.csv(gseago_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_upsetplot4, {
    output$upsetplot4 <- renderPlot({
      req(input$an_gseago)
      upsetplot(gsea_go())
    })
  })
  
  observeEvent(input$ver_dotplot4, {
    req(input$an_gseago)
    output$dotplot4 <- renderPlot({   
    if (input$expresion4=="Global"){
      dotplot(gsea_go(), showCategory = input$showcat_dotplot4, font.size=input$fontsize_dotplot4)
    }else if (input$expresion4=="Differential"){
        dotplot(gsea_go(), showCategory = input$showcat_dotplot4, font.size=input$fontsize_dotplot4, split=".sign") + facet_grid(.~.sign)
    }
    })
  })
  
  output$download_dotplot4 <- downloadHandler(
    filename = "GSEA_GO_dotplot.pdf",
    content = function(file) {
      if (input$expresion4=="Global"){
        ggsave(file, clusterProfiler::dotplot(gsea_go(), showCategory = input$showcat_dotplot4, font.size=input$fontsize_dotplot4))
      }else if (input$expresion4=="Differential"){
        ggsave(file, clusterProfiler::dotplot(gsea_go(), showCategory = input$showcat_dotplot4, font.size=input$fontsize_dotplot4, split=".sign") + facet_grid(.~.sign))
      }
    })

  gsea_go_sim4 <- reactive({
    req(input$ver_enmap4)
    pairwise_termsim(gsea_go())
  })
  
  observeEvent(input$ver_enmap4, {
    output$enmap4 <- renderPlot({
      req(input$an_gseago)
      emapplot(gsea_go_sim4(), showCategory = input$showcat_enmap4, color=input$color_enmap4, cluster.params=list(cluster=TRUE, legend=TRUE))
    })
  })
  
  output$download_enmap4 <- downloadHandler(
    filename = "GSEA_GO_enmap.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::emapplot(gsea_go_sim4(), showCategory = input$showcat_enmap4, color=input$color_enmap4, cluster.params=list(cluster=TRUE, legend=TRUE)))
    }
  )
  
  observeEvent(input$ver_goplot4, {
    output$goplot4 <- renderPlot({
      req(input$an_gseago)
      goplot(gsea_go(), showCategory = input$showcat_goplot4)
    })
  })
  
  output$download_goplot4 <- downloadHandler(
    filename = "GSEA_GO_goplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::goplot(gsea_go(), showCategory = input$showcat_goplot4))
    }
  )
  
  observeEvent(input$ver_cnetplot4, {
    output$cnetplot4 <- renderPlot({
      req(input$an_gseago)
      cnetplot(gsea_go(), showCategory = input$showcat_cnetplot4, color.params =list(foldChange =genes_gsea()))
    })
  })
  
  output$download_cnetplot4 <- downloadHandler(
    filename = "GSEA_GO_cnetplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::cnetplot(gsea_go(), showCategory = input$showcat_cnetplot4, color.params =list(foldChange =genes_gsea())))
    }
  )
  
  observeEvent(input$ver_ridgeplot4, {
    output$ridgeplot4 <- renderPlot({
      req(input$an_gseago)
      ridgeplot(gsea_go(), showCategory = input$showcat_ridgeplot4, label_format = input$label_format_ridgeplot4, fill=input$fill_ridgeplot4)+labs(x="enrichment distribution")
    })
  })

  observe({
    gseago_id4 <- gsea_go()@result$ID[input$gseago_num4]
    output$gseago_id4 <- renderText(paste("ID: ", gseago_id4))
  })
  
  observe({
    gseago_desc4 <- gsea_go()@result$Description[input$gseago_num4]
    output$gseago_desc4 <- renderText(paste("Pathway: ", gseago_desc4))
  })
  
  observeEvent(input$ver_gseaplot4, {
    output$gseaplot4 <- renderPlot({
      req(input$an_gseago)
      gseaplot(gsea_go(), by="all", title=gsea_go()@result$Description[input$gseago_num4], geneSetID = input$gseago_num4)
    })
  })
  
  gsea_go_sim_tp4 <- reactive({
    req(input$ver_tp4)
    pairwise_termsim(gsea_go())
  })
  
  observeEvent(input$ver_tp4, {
    output$tp4 <- renderPlot({
      req(input$an_gseago)
      treeplot(gsea_go_sim_tp4(), showCategory = input$showcat_tp4, color=input$color_tp4, cluster.params=list(method=input$method_tp4))
    })
  })
  
  output$download_tp4 <- downloadHandler(
    filename = "GSEA_GO_tp.pdf",
    content = function(file) {
      ggsave(file, enrichplot:: treeplot(gsea_go_sim_tp4(), showCategory = input$showcat_tp4, color=input$color_tp4, cluster.params=list(method=input$method_tp4)))
    }
  )
  
  
  ##Análisis GSEA-KEGG
  
  #Se realiza análisis GSEA-KEGG
  gsea_kegg <- eventReactive(input$an_gseakegg, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    gsea_kegg<- gseKEGG(geneList=genes_gsea(), 
                      organism=organismo_kegg(),
                      keyType="ncbi-geneid",
                      minGSSize=input$minGSSize5,
                      maxGSSize=input$maxGSSize5,
                      pAdjustMethod = input$pAdjustMethod5,
                      pvalueCutoff  =as.numeric(input$pvalue5),
                      eps  = as.numeric(input$eps5),
                      by= input$by5
      )
  })
  
  gseakegg_results <- reactive({
    if (!is.null(gsea_kegg())) {
      gseakegg_results <- data.frame(gsea_kegg())
    } else {NULL}
  })
  
  output$tabla_gseakegg <- renderDataTable({
    req(input$an_gseakegg)
    gseakegg_results()[,1:7]
  }, options = list(pageLength = 10))
  
  output$download_tabla_gseakegg <- downloadHandler(
    filename = paste("GSEA_KEGG_results.csv"),
    content = function(file) {
      write.csv(gseakegg_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_upsetplot5, {
    output$upsetplot5 <- renderPlot({
      req(input$an_gseakegg)
      upsetplot(gsea_kegg())
    })
  })
  
  observeEvent(input$ver_dotplot5, {
    req(input$an_gseakegg)
    output$dotplot5 <- renderPlot({   
      if (input$expresion5=="Global"){
        dotplot(gsea_kegg(), showCategory = input$showcat_dotplot5, font.size=input$fontsize_dotplot5)
      }else if (input$expresion5=="Differential"){
        dotplot(gsea_kegg(), showCategory = input$showcat_dotplot5, font.size=input$fontsize_dotplot5, split=".sign") + facet_grid(.~.sign)
      }
    })
  })
  
  output$download_dotplot5 <- downloadHandler(
    filename = "GSEA_KEGG_dotplot.pdf",
    content = function(file) {
      if (input$expresion5=="Global"){
        ggsave(file, clusterProfiler::dotplot(gsea_kegg(), showCategory = input$showcat_dotplot5, font.size=input$fontsize_dotplot5))
      }else if (input$expresion5=="Differential"){
        ggsave(file, clusterProfiler::dotplot(gsea_kegg(), showCategory = input$showcat_dotplot5, font.size=input$fontsize_dotplot5, split=".sign") + facet_grid(.~.sign))
      }
    })
  
  gsea_kegg_sim5 <- reactive({
    req(input$ver_enmap5)
    pairwise_termsim(gsea_kegg())
  })
  
  observeEvent(input$ver_enmap5, {
    output$enmap5 <- renderPlot({
      req(input$an_gseakegg)
      emapplot(gsea_kegg_sim5(), showCategory = input$showcat_enmap5, color=input$color_enmap5, cluster.params=list(cluster=TRUE, legend=TRUE))
    })
  })
  
  output$download_enmap5 <- downloadHandler(
    filename = "GSEA_KEGG_enmap.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::emapplot(gsea_kegg_sim5(), showCategory = input$showcat_enmap5, color=input$color_enmap5, cluster.params=list(cluster=TRUE, legend=TRUE)))
    }
  )

  observeEvent(input$ver_cnetplot5, {
    output$cnetplot5 <- renderPlot({
      req(input$an_gseakegg)
      cnetplot(gsea_kegg(), showCategory = input$showcat_cnetplot5, color.params =list(foldChange =genes_gsea()))
    })
  })
  
  output$download_cnetplot5 <- downloadHandler(
    filename = "GSEA_KEGG_cnetplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::cnetplot(gsea_kegg(), showCategory = input$showcat_cnetplot5, color.params =list(foldChange =genes_gsea())))
    }
  )
  
  observeEvent(input$ver_ridgeplot5, {
    output$ridgeplot5 <- renderPlot({
      req(input$an_gseakegg)
      ridgeplot(gsea_kegg(), showCategory = input$showcat_ridgeplot5, label_format = input$label_format_ridgeplot5, fill=input$fill_ridgeplot5)+labs(x="enrichment distribution")
    })
  })
  
  observe({
    gseakegg_id5 <- gsea_kegg()@result$ID[input$gseakegg_num5]
    output$gseakegg_id5 <- renderText(paste("ID: ", gseakegg_id5))
  })
  
  observe({
    gseakegg_desc5 <- gsea_kegg()@result$Description[input$gseakegg_num5]
    output$gseakegg_desc5 <- renderText(paste("Pathway: ", gseakegg_desc5))
  })
  
  observeEvent(input$ver_gseaplot5, {
    output$gseaplot5 <- renderPlot({
      req(input$an_gseakegg)
      gseaplot(gsea_kegg(), by="all", title=gsea_kegg()@result$Description[input$gseakegg_num5], geneSetID = input$gseakegg_num5)
    })
  })
  
  observe({
    pathway_id5 <- gsea_kegg()@result$ID[input$pathway_num5]
    output$pathway_id5 <- renderText(paste("ID: ", pathway_id5))
  })
  
  observe({
    pathway_desc5 <- gsea_kegg()@result$Description[input$pathway_num5]
    output$pathway_desc5 <- renderText(paste("Pathway: ", pathway_desc5))
  })
  
  observeEvent(input$ver_pathway5, {
    url <- paste0("http://www.kegg.jp/kegg-bin/show_pathway?", gsea_kegg()@result$ID[input$pathway_num5])
    browseURL(url)
  })
  
  gsea_kegg_sim_tp5 <- reactive({
    req(input$ver_tp5)
    pairwise_termsim(gsea_kegg())
  })
  
  observeEvent(input$ver_tp5, {
    output$tp5 <- renderPlot({
      req(input$an_gseakegg)
      treeplot(gsea_kegg_sim_tp5(), showCategory = input$showcat_tp5, color=input$color_tp5, cluster.params=list(method=input$method_tp5))
    })
  })
  
  output$download_tp5 <- downloadHandler(
    filename = "GSEA_KEGG_tp.pdf",
    content = function(file) {
      ggsave(file, enrichplot:: treeplot(gsea_kegg_sim_tp5(), showCategory = input$showcat_tp5, color=input$color_tp5, cluster.params=list(method=input$method_tp5)))
    }
  )
  
  
  ##Análisis GSEA-REACTOME
  
  #Se realiza análisis GSEA-REACTOME
  gsea_reactome <- eventReactive(input$an_gseareactome, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    gsea_reactome<- gsePathway(genes_gsea(), 
                        organism=organismo_reactome(),
                        minGSSize=input$minGSSize6,
                        maxGSSize=input$maxGSSize6,
                        pAdjustMethod = input$pAdjustMethod6,
                        pvalueCutoff  =as.numeric(input$pvalue6),
                        eps  = as.numeric(input$eps6),
                        by= input$by6
    )
  })
  
  gseareactome_results <- reactive({
    if (!is.null(gsea_reactome())) {
      gseareactome_results <- data.frame(gsea_reactome())
    } else {NULL}
  })
  
  output$tabla_gseareactome <- renderDataTable({
    req(input$an_gseareactome)
    gseareactome_results()[,1:7]
  }, options = list(pageLength = 10))
  
  output$download_tabla_gseareactome <- downloadHandler(
    filename = paste("GSEA_REACTOME_results.csv"),
    content = function(file) {
      write.csv(gseareactome_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_upsetplot6, {
    output$upsetplot6 <- renderPlot({
      req(input$an_gseareactome)
      upsetplot(gsea_reactome())
    })
  })
  
  observeEvent(input$ver_dotplot6, {
    req(input$an_gseareactome)
    output$dotplot6 <- renderPlot({   
      if (input$expresion6=="Global"){
        dotplot(gsea_reactome(), showCategory = input$showcat_dotplot6, font.size=input$fontsize_dotplot6)
      }else if (input$expresion6=="Differential"){
        dotplot(gsea_reactome(), showCategory = input$showcat_dotplot6, font.size=input$fontsize_dotplot6, split=".sign") + facet_grid(.~.sign)
      }
    })
  })
  
  output$download_dotplot6 <- downloadHandler(
    filename = "GSEA_REACTOME_dotplot.pdf",
    content = function(file) {
      if (input$expresion6=="Global"){
        ggsave(file, clusterProfiler::dotplot(gsea_reactome(), showCategory = input$showcat_dotplot6, font.size=input$fontsize_dotplot6))
      }else if (input$expresion6=="Differential"){
        ggsave(file, clusterProfiler::dotplot(gsea_reactome(), showCategory = input$showcat_dotplot6, font.size=input$fontsize_dotplot6, split=".sign") + facet_grid(.~.sign))
      }
    })
  
  gsea_reactome_sim6 <- reactive({
    req(input$ver_enmap6)
    pairwise_termsim(gsea_reactome())
  })
  
  observeEvent(input$ver_enmap6, {
    output$enmap6 <- renderPlot({
      req(input$an_gseareactome)
      emapplot(gsea_reactome_sim6(), showCategory = input$showcat_enmap6, color=input$color_enmap6, cluster.params=list(cluster=TRUE, legend=TRUE))
    })
  })
  
  output$download_enmap6 <- downloadHandler(
    filename = "GSEA_REACTOME_enmap.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::emapplot(gsea_reactome_sim6(), showCategory = input$showcat_enmap6, color=input$color_enmap6, cluster.params=list(cluster=TRUE, legend=TRUE)))
    }
  )
  
  observeEvent(input$ver_cnetplot6, {
    output$cnetplot6 <- renderPlot({
      req(input$an_gseareactome)
      cnetplot(gsea_reactome(), showCategory = input$showcat_cnetplot6, color.params =list(foldChange =genes_gsea()))
    })
  })
  
  output$download_cnetplot6 <- downloadHandler(
    filename = "GSEA_REACTOME_cnetplot.pdf",
    content = function(file) {
      ggsave(file, clusterProfiler::cnetplot(gsea_reactome(), showCategory = input$showcat_cnetplot6, color.params =list(foldChange =genes_gsea())))
    }
  )
  
  observeEvent(input$ver_ridgeplot6, {
    output$ridgeplot6 <- renderPlot({
      req(input$an_gseareactome)
      ridgeplot(gsea_reactome(), showCategory = input$showcat_ridgeplot6, label_format = input$label_format_ridgeplot6, fill=input$fill_ridgeplot6)+labs(x="enrichment distribution")
    })
  })
  
  observe({
    gseareactome_id6 <- gsea_reactome()@result$ID[input$gseareactome_num6]
    output$gseareactome_id6 <- renderText(paste("ID: ", gseareactome_id6))
  })
  
  observe({
    gseareactome_desc6 <- gsea_reactome()@result$Description[input$gseareactome_num6]
    output$gseareactome_desc6 <- renderText(paste("Pathway: ", gseareactome_desc6))
  })
  
  observeEvent(input$ver_gseaplot6, {
    output$gseaplot6 <- renderPlot({
      req(input$an_gseareactome)
      gseaplot(gsea_reactome(), by="all", title=gsea_reactome()@result$Description[input$gseareactome_num6], geneSetID = input$gseareactome_num6)
    })
  })
  
  observe({
    pathway_id6 <- gsea_reactome()@result$ID[input$pathway_num6]
    output$pathway_id6 <- renderText(paste("ID: ", pathway_id6))
  })
  
  observe({
    pathway_desc6 <- gsea_reactome()@result$Description[input$pathway_num6]
    output$pathway_desc6 <- renderText(paste("Pathway: ", pathway_desc6))
  })
  
  observeEvent(input$ver_pathway6, {
    output$pathway6 <- renderPlot({
      req(input$an_gseareactome)
      viewPathway(gsea_reactome()@result$Description[input$pathway_num6], readable=TRUE)
    })
  })
  
  output$download_pathway6 <- downloadHandler(
    filename = "GSEA_REACTOME_pathway.pdf",
    content = function(file) {
      ggsave(file, ReactomePA::viewPathway(gsea_reactome()@result$Description[input$pathway_num6], readable=TRUE))
    }
  ) 
  
  observe({
    r_pathway_id6 <- gsea_reactome()@result$ID[input$r_pathway_num6]
    output$r_pathway_id6 <- renderText(paste("ID: ", r_pathway_id6))
  })
  
  observe({
    r_pathway_desc6 <- gsea_reactome()@result$Description[input$r_pathway_num6]
    output$r_pathway_desc6 <- renderText(paste("Pathway: ", r_pathway_desc6))
  })
  
  observeEvent(input$r_ver_pathway6, {
    url <- paste0("https://reactome.org/PathwayBrowser/#/", gsea_reactome()@result$ID[input$r_pathway_num6])
    browseURL(url)
  })
  
  gsea_reactome_sim_tp6 <- reactive({
    req(input$ver_tp6)
    pairwise_termsim(gsea_reactome())
  })
  
  observeEvent(input$ver_tp6, {
    output$tp6 <- renderPlot({
      req(input$an_gseareactome)
      treeplot(gsea_reactome_sim_tp6(), showCategory = input$showcat_tp6, color=input$color_tp6, cluster.params=list(method=input$method_tp6))
    })
  })
  
  output$download_tp6 <- downloadHandler(
    filename = "GSEA_REACTOME_tp.pdf",
    content = function(file) {
      ggsave(file, enrichplot:: treeplot(gsea_reactome_sim_tp6(), showCategory = input$showcat_tp6, color=input$color_tp6, cluster.params=list(method=input$method_tp6)))
    }
  )
  
  
  ##Análisis SPIA
  
  #Se define genes seleccionados para el análisis
  genes_spia <- reactive({
    req(input$genes7)
      if (input$genes7 == "Initial Toptable") {
      gene_list_spia <- df()$logFC
      names(gene_list_spia)<-as.character(df()$EntrezID)
      gene_list_spia<-na.omit(gene_list_spia)
      gene_list_spia <- gene_list_spia[which(duplicated(names(gene_list_spia)) == F)]
      return(gene_list_spia)
    } else if (input$genes7 == "Filter Toptable"){
      if (input$regulacion7 == "Up-regulated") {
        sig_genes_df_spia = subset(df(), adj.P.Val < as.numeric(input$adjpval7)) 
        gene_list_spia <- sig_genes_df_spia$logFC
        names(gene_list_spia) <- sig_genes_df_spia$EntrezID
        gene_list_spia <- na.omit(gene_list_spia)
        gene_list_spia <- gene_list_spia[which(duplicated(names(gene_list_spia)) == F)]
        gene_list_spia <- gene_list_spia[gene_list_spia > input$logFC7] 
        return(gene_list_spia)
      } else if (input$regulacion7 == "Down-regulated"){
        sig_genes_df_spia = subset(df(), adj.P.Val < as.numeric(input$adjpval7)) 
        gene_list_spia <- sig_genes_df_spia$logFC
        names(gene_list_spia) <- sig_genes_df_spia$EntrezID
        gene_list_spia <- na.omit(gene_list_spia)
        gene_list_spia <- gene_list_spia[which(duplicated(names(gene_list_spia)) == F)]
        gene_list_spia <- gene_list_spia[gene_list_spia < -(input$logFC7)] 
        return(gene_list_spia)
      } else if (input$regulacion7 == "Up/Down-regulated") {
        sig_genes_df_spia = subset(df(), adj.P.Val < as.numeric(input$adjpval7)) 
        gene_list_spia <- sig_genes_df_spia$logFC
        names(gene_list_spia) <- sig_genes_df_spia$EntrezID
        gene_list_spia <- na.omit(gene_list_spia)
        gene_list_spia <- gene_list_spia[which(duplicated(names(gene_list_spia)) == F)]
        gene_list_spia <- gene_list_spia[abs(gene_list_spia) > input$logFC7] 
        return(gene_list_spia)
      }
    }
  })
  
  #Se define lista de referencia
  referencia <- reactive({
    req(input$referencia7)
    if (input$referencia7 == "Initial list") {
      referencia_list<-as.character(df()$EntrezID)
      referencia_list<-na.omit(referencia_list)
      referencia_list<- referencia_list[which(duplicated(referencia_list) == F)]
      return(referencia_list)
    } else if (input$referencia7 == "Genome"){
      if (input$organismo == "Mouse") { 
        library(org.Mm.eg.db)
        referencia_list<-select(org.Mm.eg.db, keys=keys(org.Mm.eg.db), columns="ENTREZID")
        referencia_list<- as.character(referencia_list$ENTREZID)
        return(referencia_list)
      } else if (input$organismo == "Human"){
        library(org.Hs.eg.db)
        referencia_list<-select(org.Hs.eg.db, keys=keys(org.Hs.eg.db), columns="ENTREZID")
        referencia_list<- as.character(referencia_list$ENTREZID)
        return(referencia_list)
      } else if (input$organismo == "Rat"){ 
        library(org.Rn.eg.db)
        referencia_list<-select(org.Rn.eg.db, keys=keys(org.Rn.eg.db), columns="ENTREZID")
        referencia_list<- as.character(referencia_list$ENTREZID)
        return(referencia_list)
      }
    }
  })
  
  #Visualizar en tabla Lista de genes seleccionada SPIA
  observeEvent(input$ver_lista_seleccionados_spia, {
    output$tabla_seleccionada_spia <- renderDataTable({
      req(input$file_carga)
      tabla_genes_spia <- cbind(names(genes_spia()),genes_spia())
      colnames(tabla_genes_spia)=c("Genes", "logFC")
      if (!is.null(tabla_genes_spia)) {
        tabla_genes_spia_ver <- data.frame(tabla_genes_spia)
        return(tabla_genes_spia_ver)
      }
    },options = list(pageLength = 10))
  })
  
  ##Análisis función spia()
  
  spia_kegg <- eventReactive(input$an_spia, {
    showModal(modalDialog(
      title = "Realizando análisis",
      "Por favor espere mientras se realiza el análisis...",
      footer = NULL
    ))
    on.exit(removeModal())
    spia_kegg<- spia(de = genes_spia(), 
                     all = referencia(), 
                     nB=input$nB7, 
                     organism=organismo_kegg(),
                     verbose=FALSE)
    return(spia_kegg)
  })
  
  spia_results <- reactive({
    if (!is.null(spia_kegg())) {
      spia_results <- data.frame(spia_kegg())
    } else {NULL}
  })
  
  output$tabla_spia <- renderDataTable({
    req(input$an_spia)
    spia_results()[,1:11]
  }, options = list(pageLength = 10))
  
  output$download_tabla_spia <- downloadHandler(
    filename = paste("SPIA_results.csv"),
    content = function(file) {
      write.csv(spia_results(), file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ver_plotP7, {
    output$plotP7 <- renderPlot({
      req(input$an_spia)
      plotP2(spia_kegg(), threshold=input$threshold7)
    })
  })
  
  output$download_plotP7 <- downloadHandler(
    filename = "SPIA_plotP.pdf",
    content = function(file) {
      ggsave(file, SPIA::plotP2(spia_kegg(), threshold=input$threshold7))
    }
  )
  
  observe({
    pathway_id7 <- spia_results()[input$pathway_num7,2]
    output$pathway_id7 <- renderText(paste("Pathway: ", pathway_id7))
  })
  
  observe({
    pathway_desc7 <- spia_results()[input$pathway_num7,1]
    output$pathway_desc7 <- renderText(paste("Pathway: ", pathway_desc7))
  })
  
  observeEvent(input$ver_pathway7, {
    url <- paste0(spia_results()[input$pathway_num7,12])
    browseURL(url)
  })
  
  #Informe ORA-GO
  output$downloadReport_ORAGO <- downloadHandler(
    filename = function() {
      paste('Informe_ORAGO', sep = '.', switch(
        input$format_ORAGO, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_ORAGO.Rmd')
      temp_name <- paste0("report_ORAGO", as.integer(Sys.time()), ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_ORAGO,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )
  
  #Informe ORA-KEGG
  output$downloadReport_ORAKEGG <- downloadHandler(
    filename = function() {
      paste('Informe_ORAKEGG', sep = '.', switch(
        input$format_ORAKEGG, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_ORAKEGG.Rmd')
      temp_name <- paste0("report_ORAKEGG", as.integer(Sys.time()), ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_ORAKEGG,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )
  
  #Informe ORA-REACTOME
  output$downloadReport_ORAREACTOME <- downloadHandler(
    filename = function() {
      paste('Informe_ORAREACTOME', sep = '.', switch(
        input$format_ORAREACTOME, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_ORAREACTOME.Rmd')
      temp_name <- paste0("report_ORAREACTOME.Rmd", as.integer(Sys.time()), ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_ORAREACTOME,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )
  
  #Informe GSEA-GO
  output$downloadReport_GSEAGO <- downloadHandler(
    filename = function() {
      paste('Informe_GSEAGO', sep = '.', switch(
        input$format_GSEAGO, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_GSEAGO.Rmd')
      temp_name <- paste0("report_GSEAGO_", as.integer(Sys.time()), ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_GSEAGO,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )
  
  #Informe GSEA-KEGG
  output$downloadReport_GSEAKEGG <- downloadHandler(
    filename = function() {
      paste('Informe_GSEAKEGG', sep = '.', switch(
        input$format_GSEAKEGG, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_GSEAKEGG.Rmd')
      temp_name <- paste0("report_GSEAKEGG_", as.integer(Sys.time()), ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_GSEAKEGG,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )
  
  #Informe GSEA-REACTOME
  output$downloadReport_GSEAREACTOME <- downloadHandler(
    filename = function() {
      paste('Informe_GSEAREACTOME', sep = '.', switch(
        input$format_GSEAREACTOME, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_GSEAREACTOME.Rmd')
      temp_name <- paste0("report_GSEAREACTOME.Rmd", as.integer(Sys.time()), ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_GSEAREACTOME,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )

  # Informe SPIA
  output$downloadReport_SPIA <- downloadHandler(
    filename = function() {
      paste('Informe_SPIA', sep = '.', switch(
        input$format_SPIA, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      showModal(modalDialog(
        title = "Generando Informe",
        "Por favor espere mientras se genera el informe...",
        footer = NULL
      ))
      
      src <- normalizePath('report_SPIA.Rmd')
      temp_name <- tempfile(fileext = ".Rmd")
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, temp_name, overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(temp_name, switch(
        input$format_SPIA,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
      on.exit({
        removeModal()
        file.remove(temp_name)
        setwd(owd)
      })
    }
  )
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
