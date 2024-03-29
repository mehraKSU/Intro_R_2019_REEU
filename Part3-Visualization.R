# 
# Let's visualize our data
# ========================
# 
# So far we have covered:
# 
#  - data types in R
#  - reading in data
#  - subsetting data
#  - reading documentation
#  - using functions
#  - saving data
#  
# Of course, we haven't used one of R's most powerful assets: graphics. This 
# section is dedicated to creating a plot from the data. While R has very
# powerful default plotting functions, we will be using the "ggplot2" package
# as it relies on a consistent "grammar of graphics" that gives a clear
# relationship between the data and the visualization.
# 
# ### What is ggplot2?
# 
# The package *ggplot2* is built off of the "grammar of graphics" in which 
# plots are built layer by layer, starting with the coordinate plane
# and then adding geometric elements like lines, dots, bars, etc, and assigning
# metadata to values like color or shape. 
# 
# The advantage of ggplot2 over R's native plotting is that the plots are saved
# as R objects and can be modified by adding layers or even replacing data. This
# tutorial will begin to scratch the surface of how to use ggplot2, but to get a
# better idea of what is possible, you can browse the resources at
# http://ggplot2.tidyverse.org/#learning-ggplot2 or examine the code of
# colleagues (e.g. Alejandro Rojas:
# https://github.com/alejorojas2/Rojas_Survey_Phytopath_2016).
# 
# 
# After this section, you should have the tools to:
# 
#  1. Create a simple plot in ggplot2
#  2. Save plots
#  3. Plot with mean and error bars
# 
# Again, since this is a four hour workshop, we do not expect mastery, but this
# at least should give you a starting point. With that in mind, let's get 
# started!
# 
# ### Getting started

install.packages("ggplot2")

library("ggplot2")

# Data for plotting with ggplot2 must be stored in a data frame

fungicide <- read.csv("data/fungicide_dat.csv") # read.csv automatically outputs a data frame


# Ready to plot? First of all let's think:
# 
# 1. What visualization might be appropriate for these data?
# 2. What should be on the axes?
# 3. Should we use lines, points, bars, boxplots, etc? 
# 
# To help facilitate your thinking, you may refer to the cheatsheet provided in the 'Help' tab
# 
# 
# Step 1: Creating our plot
# -------------------------
# 
# > Note: if you are reading this script after attending the workshop, the plot
# > may look different due to the interactive nature of the workshop. This is
# > intended as an example.
# 
# Before we begin, we should become familiar with two functions:
# 
#  - `ggplot()` initializes a ggplot object from a data set. The data set needs
#     to be a data frame.
#  - `aes()` is a general way to specify what parts of the ggplot should be 
#     mapped to variables in your data. e.g. What should be the x and y variables?
# 
# 
# ### Creating the base of the ggplot
# 
# To create our ggplot with nothing on it, we should specify two things:
# 
#  1. The data set (fungicide)
#  2. The mapping of the x and y coordinates (from the data set, using aes)
# 
# > Note, we can specify the column names without using quotation marks.

yield.plot <- ggplot(data = fungicide, 
                     mapping = aes(x = Treatment, 
                                   y = Yield_bu_per_acre))

# If everything worked, you should see nothing. This is because ggplot2 returns
# an R object. This object contains the instructions for creating the
# visualization. When you print this object, the plot is created:

yield.plot

# Now you should see a plot with nothing on it where the x and y axes are
# labeled "Treatment" and "Yield_bu_per_acre", respectively.
# 
# To break down what the above function did, it first took in the data set
# `fungicide` and then mapped the x and y aesthetics to the Treatment and
# Yield_bu_per_acre columns. Effectively, this told ggplot how big our canvas
# needs to be in order to display our data, but currently, it doesn't know
# HOW we want to display our data; we need to give it a specific geometry.
#  
# 
# ### Adding a geometry layer
# 
# All functions that add geometries to data start with `geom_`, so if we wanted
# the data to be displayed as a line showing the increase of yield over time,
# we would use `geom_line()`. If we wanted to show the data displayed as points,
# we can use `geom_point()`. 
# 
# To add a geometry or anything to a ggplot object, we can just use the `+`
# symbol. Here, we will add boxplots.
# 
# > Note: From here on out, I will be wrapping all commands with parentheses.
# > This allows the result of the assignment to be displayed automatically.

(yield.plot <- yield.plot + 
    geom_boxplot())

# If we want to change the color of the boxplots from white (default) to orange,
# we can do this by adding `geom_boxplot(fill = "orange")`.

(yield.plot <- yield.plot + 
    geom_boxplot(fill = "orange"))

# Instead of all the boxplots having the same color, it will be interesting if we
# could color them according to the Treatment.

(yield.plot <- yield.plot + 
    geom_boxplot(fill = Treatment))

# Oops! There was an error. It cannot recognize that we are talking about the
# Treatment column from our data set. This is because we have to use the function
# `aes()` whenever we are referring to our data set. 

(yield.plot <- yield.plot + 
    geom_boxplot(aes(fill = Treatment))) # This works!

# To give a title to our plot, we can use `ggtitle()`. 

(yield.plot <- yield.plot + 
    ggtitle("Effect of Fungicides on Yield"))

# We now have a fully functional and informative plot using only few lines of
# code! Producing a visualization of your data can be an extremely useful tool
# for analysis, because it can allow you to see if there are any strange patterns
# or spurious correlations in your variables. 
# 
# We can click on 'Zoom' to view a bigger version of this plot. 
# 
# Of course, this plot is not quite publication ready. We need to add some
# customization. Let's manipulate the aesthetics of the plot in how the data and
# labels are displayed. But first, use the cheatsheet or 'Google' to do the
# following exercises:
# 
# ### Exercise 1: Create `new_plot` that is similar to `yield.plot`, but the
# ### geometry is a violin plot instead of a box plot.

new_plot <- ggplot(fungicide, 
                   aes(x = Treatment, 
                       y = Yield_bu_per_acre)) +
  geom_violin(aes(fill=Treatment)) +
  ggtitle("Effect of Fungicides on Yield")

new_plot

# ### Exercise 2: Add another layer to the `new_plot` that flips the 
# ### co-ordinate axes (rotates the plot at right angle).

new_plot <- new_plot +
  coord_flip()

new_plot

# 
# ### Changing axes labels 
# 
# This is easily done with `xlab()` and `ylab()`:

(yield.plot <- yield.plot + xlab("Treatment Applied"))

(yield.plot <- yield.plot + ylab("Yield (bu/acre)"))

# The labels are now okay, but it's still not publication-ready. The font is too
# small, the background should have no gridlines and the axis text needs to be
# darker.  
# 
# ### Adjusting Look and Feel (theme)
# 
# The first thing we can do is change the default theme from `theme_grey()` to
# `theme_bw()`. We will simultaneously set the base size of the font to be 14pt.
# 
(yield.plot <- yield.plot + 
    theme_bw(base_size = 14))
# 
# There are many different default themes available for ggplot2 objects that
# change many aspects of the look and feel. The *ggthemes* contains many popular
# themes such as fivethirtyeight and economist. Of course, we can make it
# prettier before including it in our final manuscript.
# 
# To adjust granular aspects of the theme, we can use the `theme()` function, 
# which contains a whopping 71 different options all related to the layout of
# the non-data aspects of the plot.
# 
# 
# ### Exercise 3: Look at `?theme` and figure out the following:
# 1. change the aspect ratio of the panels
# 2. remove the background grid in the panels

?theme

# 
# When we inspect the help page of the `theme()` function, we can find out how
# to adjust several parameters to make our plot look acceptable:
# 

(yield.plot <- yield.plot + 
    theme(aspect.ratio = 1)) # This looks the same

(yield.plot <- yield.plot + 
    theme(aspect.ratio = 2)) # This is too skinny

(yield.plot <- yield.plot + 
    theme(aspect.ratio = 1.25)) # I think this is perfect!

(yield.plot <- yield.plot + 
    theme(panel.grid = element_blank()))

# 
# 
# Since the information in the legend is repetitive, we can remove it. If you 
# 'Google' how to remove the legend in ggplot2, you will find that you can use
# `guides(fill=FALSE)`.
# 
(yield.plot <- yield.plot + 
    guides(fill = FALSE))
# 
# 
# 
# 
# ### Putting it all together
# 
# Because we can add information to a plot with the `+` symbol, we can add all
# of the elements in one go. Let's combine what we have above.
# 
yield.plot <- ggplot(fungicide, 
                     aes(x = Treatment, 
                         y = Yield_bu_per_acre)) +
  
  geom_boxplot(aes(fill = Treatment)) +
  
  ggtitle("Effect of Fungicides on Yield") +
  
  xlab("Treatment Applied") +
  ylab("Yield (bu/acre)") +
  
  theme_bw(base_size = 14) +
  
  theme(aspect.ratio = 1.25, # We can provide multiple arguments 
        panel.grid = element_blank()) +
  
  guides(fill=FALSE)

yield.plot

# How can we show that the boxplot of Fungicide_B is significantly different?
# Hint:`annotate` it.

?annotate

# ### Exercise 4: Unravel the working of `annotate` by pasting examples in the console.

(yield.plot <- yield.plot +
    annotate(geom = "text",
             x = 3, 
             y = 176.5, 
             label = "P < 0.05",
             color = "red", 
             size = 5))

# Congratulations! Your plot is ready for publishing!
# 
# We can now create a similar plot for Severity Data.

severity.plot <- ggplot(fungicide, 
                        aes(x = Treatment, y = Severity)) +
  
  geom_boxplot() +
  
  ggtitle("Effect of Fungicides on Disease Severity") +
  
  theme_bw(base_size = 14) +
  theme(aspect.ratio = 1.5,
        panel.grid = element_blank()) +
  
  xlab("Treatment Applied") +
  ylab("Disease Severity")

severity.plot

# 
# The text of the title is not in the center. To format text elements of the
# plot, we can use the function `element_text()` inside `theme()`. Since we
# need to edit the text of the plot title, we need to specify 
# `plot.title = element_text()`. 

(severity.plot <- severity.plot + 
    theme(plot.title = element_text(hjust = 0.5)))

# 
# Step 2: Saving our plot
# -----------------------
# 
# Now that we have our plot finished, we can save it with the `ggsave()`
# function, which allows us to save it as a pdf, png, svg, eps, etc. file.
# Or, we can click on 'Export' (button just above the plot) and save it. 

# Create a folder called 'results' to save the graph into
dir.create("results")

ggsave(filename = "results/figure1.png", width = 130, units = "mm")

# 
# Step 3: Plotting with mean and error bars
# -----------------------------------------
# 
# One another type of plot that is very common in applied agricultural data
# sets is that has mean and standard errors for each treatment. Mean can be 
# depicted in terms of bars or points on the plot. Let's practice this on
# fungicide data.
# 
# Before we can plot mean and standard errors, we have to calculate them first,
# by using techniques we learned in Part 2 of the workshop. We will need to load
# `dplyr` and `plotrix`. Base 'R' does not contain a function to calculate standard
# error, but the package `plotrix` does. Moreover, this package can has functions 
# for creating specialized plots and other plotting accessories.

library("dplyr")

install.packages("plotrix")

library("plotrix")

fungicide_m_se <- fungicide %>%
  select(Treatment, Severity) %>%
  group_by(Treatment) %>%
  summarise(mean_sev = mean(Severity),
            se_sev = std.error(Severity))

# Now, we can create a plot with mean and standard error

m_se_plot <- ggplot(data = fungicide_m_se,
                    aes(x = Treatment,
                        y = mean_sev))
m_se_plot  

# ### Bar graph with standard errors

(m_se_plot_bar <- m_se_plot + 
    geom_col(aes(fill = Treatment),
             width = 0.5)) 

(m_se_plot_bar <- m_se_plot_bar +
    geom_errorbar(aes(ymin = mean_sev - se_sev,
                      ymax = mean_sev + se_sev),
                  width = 0.2)) 

# ### Point plot with standard errors

(m_se_plot_point <- m_se_plot + 
    geom_point(aes(color = Treatment),
               size = 3))

(m_se_plot_point <- m_se_plot_point + 
    geom_errorbar(aes(ymin = mean_sev - se_sev,
                      ymax = mean_sev + se_sev,
                      color = Treatment),
                  width = 0.1))

# You can follow the same steps that we followed for `yield.plot` to transform these
# plots to publication quality. To learn more about the publication ready graphics
# you can refer to another very useful R package `ggpubr` 
# (https://rpkgs.datanovia.com/ggpubr/index.html).  
  
