### Intro to data-wrangling and plotting in R tidyverse

#### Goals of this tutorial:

#   Get a basic grasp of popular R libraries to wrangle data
#   Quickly create nice plots from said data
#   Give examples to apply to your own data

#### Included:

#   Accompanying PowerPoint presentation

#   List of links to cool pages for inspiration and learning

#   Dataset used in this tutorial so that you're able to run the code yourself

#The first thing we'll do is import libraries we need for analysis. Basic R is OK for plotting but is slow and potentially really frustrating when data wrangling... And that's frustrating to begin with!

### Tidyverse

#Tidyverse is a suit of packages created for data science. You could import the packages included separately (will take less time to load), but I am generally just lazy enough to import tidyverse. 

#More information: [\<https://www.tidyverse.org\>](https://www.tidyverse.org/)

#We'll be utilizing:

#1.  [dplyr](https://dplyr.tidyverse.org/)

#2.  [ggplot2](https://ggplot2.tidyverse.org/)

# if running on your own machine that does not have tidyverse installed, uncomment and run the following line. Otherwise no need.

#install.packages('tidyverse')
#install.package('viridis')         # cool color schemes that are color-blind compatible

library(tidyverse)
library(viridis)


### Importing data

#R will import nearly any type of data file, but it's important to know the faults and nuances of your dataframe before attempting (e.g., Do you have missing data? How are they marked? Do you have numerical values? Characters? Both?)

#Today we'll import a .CSV file using read.delim() to a variable called df.



#We see that there are some missing values in this table (Charmander is only Fire type, duh...), so we should replace these missing values with N/A so that they're easy to ignore and don't get lost in the shuffle.

#We can raise the na.strings argument.

df <- read.delim("Pokemon.csv",                  # if data is located in another directory, you need to specify the path here. 
                 sep = ",",                    # tell R cells are separated by commas
                 na.strings = c("", "NA"),     # fill missing values with "NA" character
                 stringsAsFactors = F)         # do not automatically make variables factors


head(df)                                         # look at first 6 rows of the dataframe


#Better! Now we can easily ignore these cells.

### Dplyr

#dply` uses a variety of verbs and pipes (%>%) to transform your data.

#What is a pipe?

#   Think of a pipe as saying "and then" between command lines.

#   This allows you to string multiple verbs together to get your ideal end product

#   Quicker than utilizing `for` and `if/else` loops

#### Dplyr verbs to remember

#| term          | description                          |
#|---------------|--------------------------------------|
#| `select()`    | select specific columns in dataframe |
#| `filter()`    | filter rows of specific values       |
#| `arrange()`   | re-order dataframe based on a row    |
#| `mutate()`    | create a new column                  |
#| `summarise()` | summarize column values              |
#| `group_by()`  | allow for group operations           |

### Using dplyr to get summary statistics

#dplyr follows a particular formatting where the dataframe is first specified, followed by a pipe, followed by whatever transformations you would like to make.

#df %>% transformation()

#To save our changes to a variable, we just assign it to value as we did initially

#df.cool <- df %>% transformation()

#Let's say we were interested in summarizing how Attack stats differ between Pokemon types, but only for Generation 1.

#Steps:

#1.  Select columns wanted to perform actions (optional, just makes things neater)
#2.  Filter rows where Generation value equals 1
#3.  Group by the Type.1 variable
#4.  Calculate the number of Pokemon within each Type, their mean Attack, and standard deviation Attack


summary <-  df %>%                          # assign our Attack stats to a new dataframe
  
  select(-X.) %>%                 # select all columns EXCEPT X.
  
  filter(Generation == 1) %>%     # only select Pokemon in Gen. 1
  
  group_by(Type.1) %>%            # Group Pokemon by their Type to create averages
  
  summarize(n = n(),              # Create a summary table that includes a count
            mean.Attack = mean(Attack),          # mean
            sd.Attack = sd(Attack))              # and standard deviation

summary


#### Creating new variables

#Often we want to create new columns to our existing dataset. For instance, we might want to know the total value of each Pokemon. This can easily be calculated using `mutate()`.



df <- df %>%                               # just updating the current dataframe
  group_by(Name) %>%                   # We want to calculate the total for each Pokemon
  mutate(Total = sum(HP, Attack, Defense, Sp..Atk, Sp..Def, Speed)) # new variable Total

# side note: if you need to ever implement just one dplyr verb, you can do so without pipes!

mutate(df, Total = sum(HP, Attack, Defense, Sp..Atk, Sp..Def, Speed))



#We also can use conditional statements to create new variables based on existing columns. Perhaps we want to categorized Pokemon based on whether they have greater Defense or Attack stats.

#With real datasets we would probably have finer classifications, but this is just an example.

#Because we have two options (Defensive/Offensive), we can use mutate() and ifelse()

#We can then choose to only look at Pokemon who are considered Defensive using filter()


df %>% 
  group_by(Name) %>%
  mutate(DO = ifelse(Defense > Attack,"Defensive", "Offensive")) %>%
  filter(DO == "Defensive")



#As mentioned before, we can either save the dataframe with these new variables, but if we're just grouping to plot, we might not want to. Otherwise we might end up with df1, df2, df3... Instead, we can move straight from using dplyr to plotting with ggplot using a pipe.


df %>% 
  mutate(DO = ifelse(Defense > Attack,"Defensive", "Offensive")) %>%
  filter(DO == "Defensive") %>%
  ggplot(aes(x = Defense, y = Attack)) +
  geom_point()


### ggplot

#### basics

#ggplot() creates plots in layers

#   visual items are referred to as geoms, short for geometric objects

#   geoms answer the question of *how* we want to plot our data

#   geoms come in many shapes and we can add more than one to our plot

#   aesthetics of the plot can be controlled with... aesthetics, which are referred to as aes

#  aes() stands for aesthetic, or "something you can see." Each aesthetic used maps a visual cue to a variable (<https://beanumber.github.io/sds192/lab-ggplot2.html>)

#   Can be used to vary colors, shapes, sizes, transparencies...etc

#   Some geoms have specific aesthetics that work only for them. You can always check by typing ?geom_<NAME>() into your command line, replacing \<NAME\> with your geom of choice.

#ggplot follows the following formula where \<\> indicates input from the user:

#    ggplot(<dataset>, aes(x = <x.variable>, y = <y.variable>)

#After specifying our dataset, X and Y variables we can tell ggplot how we want to display the data using a `geom` command. Notice that ggplot does not use pipes, but + as an indicator that the next line is included in the plot.

#        ggplot(<dataset>, aes(x = <x.variable>, y = <y.variable>) +
geom_point()

#Basic examples:


ggplot(df, aes(x = Attack, y = Defense)) +
  geom_point()


ggplot(df, aes(x = Type.1, y = Attack)) +
  geom_boxplot()


#Even without aesthetics we can make pretty decent basic plots. But aesthetics will help us draw attention to what matters in our visualizations.

##### Here's where it gets a teeny bit tricky...

#Aesthetics can belong either inside or outside parentheses and this changes what they impact.

#-   Aesthetics placed inside parentheses set the aesthetic based on a variable.

#    -   For example, if we wanted colors to be different for Pokemon types.


# impact of specifying inside parentheses

ggplot(df, aes(x = Attack, y = Defense)) +
  geom_point(aes(color = Type.1))


#-   Aesthetics placed outside of parentheses set the aesthetic to a specific value

#    -   If we wanted all points to be red instead of the default black.


# impact of setting outside of parentheses
ggplot(df, aes(x = Attack, y = Defense)) +
  geom_point(color = "red")


#Aesthetics can also be specific to a geom (as shown above), or set globally to impact all geoms.


# setting a global aesthetic

ggplot(df, aes(x = Type.1, y = Attack, color = Type.1)) +
  geom_boxplot() + 
  geom_jitter()


#Yikes, that is maybe a bit of an eyesore, but you get the idea. Sometimes it's better to set aesthetics to a specific geom instead!

ggplot(df, aes(x = Type.1, y = Attack)) +
  geom_boxplot() + 
  geom_jitter(aes(color = Type.1))


#We can take this even further by modifying the plot with more aesthetics outside of parentheses.

#We can manipulate:

#-   transparency using alpha

#-   size using size

#-   type of line used linetype

#-   shape of a point point

#And the list continues! Again, you can always check what aesthetics are available to specific geom by checking its help page.

#For example, we can use the aesthetic `width` for `geom_jitter()` (scatterplot) to set the width of the jitter, but we would get an error if we tried to use it for `geom_point()`.


ggplot(df, aes(x = Type.1, y = Attack)) +
  geom_boxplot(alpha = 0.5,                     # make boxplots transparent
               size = 0.75) +                   # make outlines a little thicker
  geom_jitter(aes(color = Type.1),
              width = 0.25,                     # set the width of the jitter
              size = 0.5)                       # make points smaller than default


#### Labels

#Labels can be specified pretty easily with the `lab()` option, allowing us to override the default which are just the column names from the dataframe.


ggplot(df, aes(x = Type.1, y = Attack)) +
  geom_boxplot(alpha = 0.5,                     
               size = 0.75) +                   
  geom_jitter(aes(color = Type.1),
              width = 0.25,                     
              size = 0.5) +
  labs(x = "Pokemon type",                       # x-axis label
       y = "Attack statistic",                   # y-axis label
       title = "Attack stats by Pokemon type")   # plot title


#### Editing the global theme

#There are obviously some unsightly things we should take care of

#-   overlap of x-axis text :(
  
#  -   redundant legend :(
    
#    -   ugly gray default background :(
      
#      We can make general changes to the plot by altering the plot's theme. Here you can change almost anything you can imagine! If you don't believe me, type `?theme()` and take a look at the list.
      

      ggplot(df, aes(x = Type.1, y = Attack)) +
        geom_boxplot(alpha = 0.5,                     
                     size = 0.75) +                   
        geom_jitter(aes(color = Type.1),
                    width = 0.25,                     
                    size = 0.5) +
        labs(x = "Pokemon type",                       
             y = "Attack statistic",                   
             title = "Attack stats by Pokemon type") +
        theme(panel.background = element_rect(fill = "white"),  # change from unsightly gray to white
              legend.position = 'none',                         # begone useless legend!
              axis.text.x = element_text(angle = 45)            # put x text on an angle
        )

      
      ### Putting dplyr and ggplot together
      
 #     Sometimes we need to make specific transformations to our dataframe before we're able to plot. One such plot is the stacked bar plot. So let's pretend we wanted to visualize how total stat points are broken down by Pokemon type.
      
  #    Steps:
        
  #      1.  Create a dataframe that includes averages of each stat for each Pokemon type
  #    2.  Transpose the data from wide to long format
  #    3.  Plot!
        

      # 1. create a dataframe of averages
      
      df %>% 
        group_by(Type.1) %>%
        summarize(Avg.Total = mean(Total),
                  Avg.HP = mean(HP),
                  Avg.Attack = mean(Attack),
                  Avg.Defense = mean(Defense),
                  Avg.SpAtk = mean(Sp..Atk),
                  Avg.SpDef = mean(Sp..Def)) 

      
 #     Transposing the dataframe uses a new verb we haven't gone over, `gather()` which takes three values:

#-   **Key:** the name of your new column that will store the old column names

#-   **Value**: name of new column that will hold all of the old column values

#-   Which columns you'd like to include in the transpose (otherwise it will transpose all!)
      

      # 2. Transpose data from wide to long form
      
      df %>% 
        group_by(Type.1) %>%
        summarize(Avg.Total = mean(Total),
                  Avg.HP = mean(HP),
                  Avg.Attack = mean(Attack),
                  Avg.Defense = mean(Defense),
                  Avg.SpAtk = mean(Sp..Atk),
                  Avg.SpDef = mean(Sp..Def)) %>%
        gather(key = "Stat", value = "Average", Avg.HP:Avg.SpDef)

      # 3. Make a fancy plot! (this is where we'll use the viridis package)
      
      df %>% 
        group_by(Type.1) %>%
        summarize(Avg.Total = mean(Total),
                  Avg.HP = mean(HP),
                  Avg.Attack = mean(Attack),
                  Avg.Defense = mean(Defense),
                  Avg.SpAtk = mean(Sp..Atk),
                  Avg.SpDef = mean(Sp..Def)) %>%
        gather(key = "Stat", value = "Average", Avg.HP:Avg.SpDef) %>%  
        
        # transfer right into ggplot with a pipe !
        
        ggplot(aes(x = Type.1, y = Avg.Total, fill = Stat)) +
        
        geom_bar(stat = 'identity', color = 'black') + # identity just means no transforms
        
        labs(x = "Pokemon Type",
             y = "Average total stat points",
             title = "Composition of total stats by Pokemon type",
             fill = "Stat") +
        
        coord_cartesian(ylim = c(0, 3000)) +          # customize plot limits 
        
        scale_fill_viridis(discrete = TRUE) +         # our values are not continous
        # notice we're using scale FILL, because we set the fill aesthetic above
        
        scale_y_continuous(expand = c(0,0)) +         # get rid of unsightly gap at [0,0]
        
        theme_bw() +                                  # pre-set theme that is not so bad
        
        theme(axis.text.x = element_text(angle = 45,  # angle x-axis text
                                         hjust = 1))  # slide text down a bit (was peaking into plot)

      
      #### Facet-nating (Using facets)
      
 #     Sometimes it's best to display data in subplots, especially when we have a lot of different levels to a variable

3For instance, there is obviously a relationship between Defense and Attack stats, but we're also intermixing 18 groups! We've also seen that simply adding colors doesn't help, just too many groups!
        

      ggplot(df, aes(x = Attack, y = Defense)) +
        geom_point(aes(color = Type.1))

      

      ggplot(df, aes(x = Attack, y = Defense)) +
        facet_wrap(~Type.1,                   # select variable to facet by
                   nrow = 3) +                # set number of rows of plots
        
        geom_smooth(method = 'lm',             # add line of best fit
                    se = FALSE,                # don't include SE ribbon
                    size = 0.75) +             # make lines a bit more substantial
        
        geom_point(aes(color = Type.1),  
                   size = 0.65,) +
        
        theme_bw() + 
        
        theme(legend.position = 'none')

      
      
 #     ~\*~\*~\*~\*~\*~\*~\*~\*~\*~\*~FANCIFY~\*~\*~\*~\*~\*~\*~\*~\*~\*
        
 #       Let's display all data in each facet, but highlight each group!



df2 <- select(df, -Type.1)                # grab all data besides our normal grouping variable

ggplot(df, aes(x = Attack, y = Defense)) +
  facet_wrap(~Type.1,                   
             nrow = 3) +
  
  geom_point(data = df2,                  # plot our new df as a big blob of gray
             color = "gray",
             alpha = 0.35,
             size = 0.50) +
  
  geom_smooth(method = 'lm',             
              se = FALSE,               
              size = 0.75) +
  
  geom_point(aes(color = Type.1),  
             size = 0.65,) +
  
  theme_bw() + 
  
  theme(legend.position = 'none',           
        strip.background = element_blank()) # get rid of facet title backgrounds


### Saving your masterpiece

#Plots can be saved by adding a `ggsave()` command after your plot

#`ggsave('name-of-file.png', height = XXX, width = XXX, dpi = XXX)`

#-   You can save as almost any image extension (.png, .jpeg, .tiff, pdf)

#-   Specify dpi (this is handy for publications!

#-   Specify height and width

#-   Specify unit (inches, cm, mm)


df2 <- select(df, -Type.1)               

ggplot(df, aes(x = Attack, y = Defense)) +
  facet_wrap(~Type.1,                   
             nrow = 3) +
    geom_point(data = df2,             
             color = "gray",
             alpha = 0.35,
             size = 0.50) +
  geom_smooth(method = 'lm',             
              se = FALSE,               
              size = 0.75) +
  geom_point(aes(color = Type.1),  
             size = 0.65,) +
  theme_bw() + 
  theme(legend.position = 'none',           
        strip.background = element_blank())

ggsave("beautiful-plot.pdf", dpi = 600)


#And that's it! Manipulating things in R takes some time to get used to and finding the right options for your needs may require some Google searching (StackOverflow has saved me many times).
      
      ### Resources
      
 #     Here are some resources that I've found useful over the years:

#[Color Palettes](https://colorpalettes.net/category/contrasting-color/) - contrasting color palettes

#[Coolors](https://coolors.co/6a0f49-d741a7-7d83ff-007fff-2d898b-7cb518-12664f-ffa62b-59c3c3-ebebeb) - create color palettes, shuffle around colors until you find something that works

#[dplyr cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

#[ggfx](https://www.data-imaginist.com/2021/say-goodbye-to-good-taste/) - A little late for April Fool's but if you don't think your PI will kill you, you can send them a plot with a funny filter 

#[ggplot cheat sheet](https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf) - classic ggplot cheat sheet, hopefully after this tutorial it's helpful!
        
  #      [R graph gallery](https://www.r-graph-gallery.com) - awesome plotting examples for almost all types (code included)
      
  #    [tidyverse website](https://www.tidyverse.org)
      
   #   [Which color scale for dataviz?](https://blog.datawrapper.de/which-color-scale-to-use-in-data-vis/) - great blogpost about choosing color scales for different types of vizualization.
      
   #   The \#tidytuesday hashtag on Twitter (I'm serious!)\
      