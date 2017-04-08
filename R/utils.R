#' Calculate the percentage change between two choroplethr dataframes.
#' 
#' Merges df1 and df2 on column named "region", and computes percentage change from
#' df1$value to df2$value. Result is in the new "value" column, and rounded to two
#' digits.
#' 
#' @param df1 A dataframe with columns named "region" and "value"
#' @param df2 A dataframe with columns named "region" and "value"
#' @export
calculate_percent_change = function(df1, df2)
{
  stopifnot(c("region", "value") %in% colnames(df1))
  stopifnot(c("region", "value") %in% colnames(df2))
  
  # merge, calculate % change and round
  df = merge(df1, df2, by = "region")
  df$value = (df$value.y - df$value.x) / df$value.x * 100
  df$value = round(df$value, digits=2)
  
  df
}