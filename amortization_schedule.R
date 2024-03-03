###############################################
# Effective Interest Rate Amortization Schedule
###############################################

# payment (지급액)
# interest (이자)
# principal (원금)
# outstanding balance (미결제 잔액)
# guaranteed return (보장수익률)

options(scipen = 999)

library(lubridate)
library(writexl)



principal <- 15000000000
interest_rate <- 0.03
year_interest_payment_period <- 1/4
compound_interest <- 0.11
issue_date <- ymd("2023-12-15")
maturity <- ymd("2027-12-15")
total_year <- as.integer(( maturity - issue_date ) /365)

compound_amount <- principal * (1 + compound_interest) ^ total_year
interest_cum <- principal * interest_rate * year_interest_payment_period * ( total_year / year_interest_payment_period )
maturity_amount <- principal * (1 + compound_interest) ^ total_year - interest_cum

interest_payment <- rep(principal * interest_rate * year_interest_payment_period, total_year / year_interest_payment_period)
payment <- interest_payment
payment[total_year / year_interest_payment_period] <- interest_payment[total_year / year_interest_payment_period] + maturity_amount

initial_BV <- 9651687010
payment <- c(-initial_BV, payment)
print(payment)

seq(along=payment)


npv <- function(i, cf, t=seq(along=cf)) sum(cf/(1+i)^t) 
irr <- function(cf) { uniroot(npv, c(0,1), cf=cf, tol=.00000000001)$root } 
irr(payment)

irr_rate <- irr(payment)

date_seq <- seq.Date(issue_date, maturity, by = "quarter")

BV <- rep(NA, length(date_seq))
eff_interest <- rep(NA, length(date_seq))
for (i in seq(1:length(date_seq))) {
    if(i == 1){
        BV[i] = initial_BV
    } else {
        eff_interest[i] = BV[i-1] * irr_rate
        BV[i] = BV[i-1] + eff_interest[i] - payment[i]
    }
}

BV <- round(BV)


schedule <- tibble::tibble(date = date_seq,
               BV = BV,
               eff_int = eff_interest,
               payment = c(NA, payment[-1]))


