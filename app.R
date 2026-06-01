# Your complete app.R should look like this:

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Personal Finance Tracker"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard",      tabName="dashboard", icon=icon("home")),
      menuItem("Add Income",     tabName="income",    icon=icon("plus-circle")),
      menuItem("Add Expense",    tabName="expense",   icon=icon("minus-circle")),
      menuItem("Edit Income",    tabName="edit_inc",  icon=icon("edit")),
      menuItem("Edit Expense",   tabName="edit_exp",  icon=icon("edit")),
      menuItem("Delete Income",  tabName="del_inc",   icon=icon("trash")),
      menuItem("Delete Expense", tabName="del_exp",   icon=icon("trash")),
      menuItem("Visualizations", tabName="visuals",   icon=icon("chart-bar")),
      menuItem("Statistics",     tabName="stats",     icon=icon("calculator"))
    )
  ),
  dashboardBody(
    tabItems(
      # ✅ Updated Dashboard tab
      tabItem(tabName="dashboard",
              h2("📊 Dashboard"),
              fluidRow(
                valueBoxOutput("total_income"),
                valueBoxOutput("total_expense"),
                valueBoxOutput("balance"),
                valueBoxOutput("status")
              )
      ),
      tabItem(tabName="income",
              h2("💰 Add Income"),
              fluidRow(
                box(
                  title  = "Add New Income",
                  width  = 6,
                  status = "success",
                  numericInput("inc_amount", "Income Amount:", value=0, min=0),
                  textInput("inc_source", "Income Source:"),
                  actionButton("add_inc_btn", "Add Income", 
                               class="btn-success")
                ),
                box(
                  title  = "Current Income Records",
                  width  = 6,
                  status = "success",
                  tableOutput("income_table")
                )
              )
            ),
      tabItem(tabName="expense",
              h2("💸 Add Expense"),
              fluidRow(
                box(
                  title  = "Add New Expense",
                  width  = 6,
                  status = "danger",
                  numericInput("exp_amount", "Expense Amount:", value=0, min=0),
                  textInput("exp_category", "Expense Category:"),
                  actionButton("add_exp_btn", "Add Expense",
                               class="btn-danger")
                ),
                box(
                  title  = "Current Expense Records",
                  width  = 6,
                  status = "danger",
                  tableOutput("expense_table")
                )
              )
      ),
      tabItem(tabName="edit_inc",
              h2("✏️ Edit Income"),
              fluidRow(
                box(
                  title  = "Edit Income Record",
                  width  = 6,
                  status = "warning",
                  numericInput("edit_inc_pos", "Record Position:", value=1, min=1),
                  numericInput("edit_inc_amt", "New Amount:", value=0, min=0),
                  textInput("edit_inc_src", "New Source:"),
                  actionButton("edit_inc_btn", "Update Income",
                               class="btn-warning")
                ),
                box(
                  title  = "Current Income Records",
                  width  = 6,
                  status = "warning",
                  tableOutput("edit_income_table")
                )
              )
      ),
      tabItem(tabName="edit_exp",
              h2("✏️ Edit Expense"),
              fluidRow(
                box(
                  title  = "Edit Expense Record",
                  width  = 6,
                  status = "warning",
                  numericInput("edit_exp_pos", "Record Position:", value=1, min=1),
                  numericInput("edit_exp_amt", "New Amount:", value=0, min=0),
                  textInput("edit_exp_cat", "New Category:"),
                  actionButton("edit_exp_btn", "Update Expense",
                               class="btn-warning")
                ),
                box(
                  title  = "Current Expense Records",
                  width  = 6,
                  status = "warning",
                  tableOutput("edit_expense_table")
                )
              )
      ),
      # Delete Income tab
      tabItem(tabName="del_inc",
              h2("🗑️ Delete Income"),
              fluidRow(
                box(
                  title  = "Delete Income Record",
                  width  = 6,
                  status = "danger",
                  numericInput("del_inc_pos", "Record Position to Delete:", 
                               value=1, min=1),
                  actionButton("del_inc_btn", "Delete Income",
                               class="btn-danger")
                ),
                box(
                  title  = "Current Income Records",
                  width  = 6,
                  status = "danger",
                  tableOutput("del_income_table")
                )
              )
      ),
      # Delete Expense tab
      tabItem(tabName="del_exp",
              h2("🗑️ Delete Expense"),
              fluidRow(
                box(
                  title  = "Delete Expense Record",
                  width  = 6,
                  status = "danger",
                  numericInput("del_exp_pos", "Record Position to Delete:",
                               value=1, min=1),
                  actionButton("del_exp_btn", "Delete Expense",
                               class="btn-danger")
                ),
                box(
                  title  = "Current Expense Records",
                  width  = 6,
                  status = "danger",
                  tableOutput("del_expense_table")
                )
              )
      ),
      tabItem(tabName="visuals",
              h2("📈 Visualizations"),
              fluidRow(
                # Row 1 — Bar Charts
                box(
                  title  = "Income Sources",
                  width  = 6,
                  status = "primary",
                  plotOutput("inc_bar")
                ),
                box(
                  title  = "Expense Categories",
                  width  = 6,
                  status = "danger",
                  plotOutput("exp_bar")
                )
              ),
              fluidRow(
                # Row 2 — Pie Charts
                box(
                  title  = "Income Breakdown",
                  width  = 6,
                  status = "success",
                  plotOutput("inc_pie")
                ),
                box(
                  title  = "Expense Breakdown",
                  width  = 6,
                  status = "warning",
                  plotOutput("exp_pie")
                )
              ),
              fluidRow(
                # Row 3 — Comparison
                box(
                  title  = "Income vs Expense",
                  width  = 12,
                  status = "info",
                  plotOutput("comparison")
                )
              )
      ),
      tabItem(tabName="stats",
              h2("🔢 Statistics"),
              fluidRow(
                box(
                  title  = "Income Statistics",
                  width  = 6,
                  status = "success",
                  tableOutput("inc_stats")
                ),
                box(
                  title  = "Expense Statistics",
                  width  = 6,
                  status = "danger",
                  tableOutput("exp_stats")
                )
              ),
              fluidRow(
                box(
                  title  = "Correlation Analysis",
                  width  = 12,
                  status = "info",
                  textOutput("correlation")
                )
              )
      )
    )
  )
)

# ✅ Server function — paste dashboard code here!
server <- function(input, output){
  
  # Load data
  inc_df <- read.csv("income.csv")
  exp_df <- read.csv("expense.csv")
  income <- inc_df$income
  expense <- exp_df$expense
  
  # Dashboard boxes
  output$total_income <- renderValueBox({
    valueBox(
      value    = sum(income),
      subtitle = "Total Income",
      icon     = icon("dollar-sign"),
      color    = "green"
    )
  })
  
  output$total_expense <- renderValueBox({
    valueBox(
      value    = sum(expense),
      subtitle = "Total Expense",
      icon     = icon("credit-card"),
      color    = "red"
    )
  })
  
  output$balance <- renderValueBox({
    bal <- sum(income) - sum(expense)
    valueBox(
      value    = bal,
      subtitle = "Balance",
      icon     = icon("wallet"),
      color    = "blue"
    )
  })
  
  output$status <- renderValueBox({
    bal <- sum(income) - sum(expense)
    stat <- if(bal > 0) "Profit" else if(bal < 0) "Loss" else "Zero Balance"
    col  <- if(bal > 0) "green" else if(bal < 0) "red" else "yellow"
    valueBox(
      value    = stat,
      subtitle = "Status",
      icon     = icon("chart-line"),
      color    = col
    )
  })
  # Show income table
  output$income_table <- renderTable({
    inc_df <- read.csv("income.csv")
    inc_df
  })
  
  # Add income button
  observeEvent(input$add_inc_btn, {
    req(input$inc_amount > 0, input$inc_source != "")
    
    # Read existing data
    inc_df <- read.csv("income.csv")
    
    # Add new row
    new_row <- data.frame(
      income        = input$inc_amount,
      income_source = input$inc_source
    )
    
    # Save updated data
    inc_df <- rbind(inc_df, new_row)
    write.csv(inc_df, "income.csv", row.names=FALSE)
    
    # Show success message
    showNotification("✅ Income added successfully!", 
                     type="message")
  })
  # Show expense table
  output$expense_table <- renderTable({
    exp_df <- read.csv("expense.csv")
    exp_df
  })
  
  # Add expense button
  observeEvent(input$add_exp_btn, {
    req(input$exp_amount > 0, input$exp_category != "")
    
    exp_df <- read.csv("expense.csv")
    
    new_row <- data.frame(
      expense          = input$exp_amount,
      expense_category = input$exp_category
    )
    
    exp_df <- rbind(exp_df, new_row)
    write.csv(exp_df, "expense.csv", row.names=FALSE)
    
    showNotification("✅ Expense added successfully!",
                     type="message")
  })
  # Show income table in edit page
  output$edit_income_table <- renderTable({
    read.csv("income.csv")
  })
  
  # Edit income button
  observeEvent(input$edit_inc_btn, {
    req(input$edit_inc_amt > 0, input$edit_inc_src != "")
    
    inc_df <- read.csv("income.csv")
    pos    <- input$edit_inc_pos
    
    # Validate position
    if(pos < 1 || pos > nrow(inc_df)){
      showNotification("❌ Invalid position!",
                       type="error")
      return()
    }
    
    # Update record
    inc_df[pos, "income"]        <- input$edit_inc_amt
    inc_df[pos, "income_source"] <- input$edit_inc_src
    
    write.csv(inc_df, "income.csv", row.names=FALSE)
    
    showNotification("✅ Income updated successfully!",
                     type="message")
  })
  # Show expense table in edit page
  output$edit_expense_table <- renderTable({
    read.csv("expense.csv")
  })
  
  # Edit expense button
  observeEvent(input$edit_exp_btn, {
    req(input$edit_exp_amt > 0, input$edit_exp_cat != "")
    
    exp_df <- read.csv("expense.csv")
    pos    <- input$edit_exp_pos
    
    # Validate position
    if(pos < 1 || pos > nrow(exp_df)){
      showNotification("❌ Invalid position!",
                       type="error")
      return()
    }
    
    # Update record
    exp_df[pos, "expense"]          <- input$edit_exp_amt
    exp_df[pos, "expense_category"] <- input$edit_exp_cat
    
    write.csv(exp_df, "expense.csv", row.names=FALSE)
    
    showNotification("✅ Expense updated successfully!",
                     type="message")
  })
  # Show tables in delete pages
  output$del_income_table <- renderTable({
    read.csv("income.csv")
  })
  
  output$del_expense_table <- renderTable({
    read.csv("expense.csv")
  })
  
  # Delete income button
  observeEvent(input$del_inc_btn, {
    inc_df <- read.csv("income.csv")
    pos    <- input$del_inc_pos
    
    if(pos < 1 || pos > nrow(inc_df)){
      showNotification("❌ Invalid position!",
                       type="error")
      return()
    }
    
    inc_df <- inc_df[-pos, ]
    write.csv(inc_df, "income.csv", row.names=FALSE)
    showNotification("✅ Income deleted successfully!",
                     type="message")
  })
  
  # Delete expense button
  observeEvent(input$del_exp_btn, {
    exp_df <- read.csv("expense.csv")
    pos    <- input$del_exp_pos
    
    if(pos < 1 || pos > nrow(exp_df)){
      showNotification("❌ Invalid position!",
                       type="error")
      return()
    }
    
    exp_df <- exp_df[-pos, ]
    write.csv(exp_df, "expense.csv", row.names=FALSE)
    showNotification("✅ Expense deleted successfully!",
                     type="message")
  })
  # Income bar chart
  output$inc_bar <- renderPlot({
    inc_df <- read.csv("income.csv")
    barplot(inc_df$income,
            names.arg = inc_df$income_source,
            main = "Income Sources",
            xlab = "Source",
            ylab = "Amount",
            col  = "steelblue")
  })
  
  # Expense bar chart
  output$exp_bar <- renderPlot({
    exp_df <- read.csv("expense.csv")
    barplot(exp_df$expense,
            names.arg = exp_df$expense_category,
            main = "Expense Categories",
            xlab = "Category",
            ylab = "Amount",
            col  = c("red","blue"))
  })
  
  # Income pie chart
  output$inc_pie <- renderPlot({
    inc_df  <- read.csv("income.csv")
    pct_inc <- round(inc_df$income/sum(inc_df$income)*100, 1)
    lab_inc <- paste(inc_df$income_source, pct_inc, "%")
    pie(inc_df$income,
        labels = lab_inc,
        main   = "Income Breakdown",
        col    = c("red","blue","green","yellow","orange","purple","pink"))
  })
  
  # Expense pie chart
  output$exp_pie <- renderPlot({
    exp_df  <- read.csv("expense.csv")
    pct_exp <- round(exp_df$expense/sum(exp_df$expense)*100, 1)
    lab_exp <- paste(exp_df$expense_category, pct_exp, "%")
    pie(exp_df$expense,
        labels = lab_exp,
        main   = "Expense Breakdown",
        col    = c("green","orange","blue","yellow","red"))
  })
  
  # Comparison chart
  output$comparison <- renderPlot({
    inc_df     <- read.csv("income.csv")
    exp_df     <- read.csv("expense.csv")
    tot_inc    <- sum(inc_df$income)
    tot_exp    <- sum(exp_df$expense)
    balance    <- tot_inc - tot_exp
    comparison <- c(tot_inc, tot_exp)
    lab_comp   <- c("Total Income", "Total Expense")
    
    bar_obj <- barplot(comparison,
                       names.arg = lab_comp,
                       main = "Income vs Expense",
                       col  = c("skyblue","tomato"),
                       ylim = c(0, max(comparison)*1.2))
    
    text(bar_obj,
         comparison/2,
         labels = comparison,
         col    = "white",
         font   = 2,
         cex    = 1.1)
    
    title(sub = paste("Balance:", balance))
  })
  # Income statistics
  output$inc_stats <- renderTable({
    inc_df <- read.csv("income.csv")
    data.frame(
      Statistic = c("Mean", "Median", "SD", "Min", "Max", "Total"),
      Value     = c(
        round(mean(inc_df$income), 2),
        round(median(inc_df$income), 2),
        round(sd(inc_df$income), 2),
        min(inc_df$income),
        max(inc_df$income),
        sum(inc_df$income)
      )
    )
  })
  
  # Expense statistics
  output$exp_stats <- renderTable({
    exp_df <- read.csv("expense.csv")
    data.frame(
      Statistic = c("Mean", "Median", "SD", "Min", "Max", "Total"),
      Value     = c(
        round(mean(exp_df$expense), 2),
        round(median(exp_df$expense), 2),
        round(sd(exp_df$expense), 2),
        min(exp_df$expense),
        max(exp_df$expense),
        sum(exp_df$expense)
      )
    )
  })
  
  # Correlation
  output$correlation <- renderText({
    inc_df <- read.csv("income.csv")
    exp_df <- read.csv("expense.csv")
    
    if(nrow(inc_df) != nrow(exp_df)){
      paste("ℹ️ Correlation unavailable —",
            "Income records:", nrow(inc_df),
            "Expense records:", nrow(exp_df),
            "— Equal records needed!")
    } else {
      cor_val <- round(cor(inc_df$income, exp_df$expense), 4)
      cor_int <- if(abs(cor_val) >= 0.8) "Strong" else
        if(abs(cor_val) >= 0.5) "Moderate" else
          if(abs(cor_val) >= 0.2) "Weak" else "No correlation"
      paste("Correlation:", cor_val, "→", cor_int)
    }
  })
}  # ← end of server function

shinyApp(ui, server)