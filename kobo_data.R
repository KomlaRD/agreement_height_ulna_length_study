# Load library
library(KoboconnectR)

# Params for koboserver
url <- "kf.kobotoolbox.org"
username <- "ericanku"
password <- "Amakobocollect2023."

# Check API token
get_kobo_token(url = url, uname = username, pwd = password)

# List of forms and their asset ids
kobotools_api(url = url, uname = username, pwd = password, simplified = F)


# Import data
df <- kobo_df_download(url = url, uname = username, pwd = password, assetid = "aQRWXX7wtqZ2KKSPiyg2hd")
