global class CalculatorUtility {

    global static decimal PMT(string ir, string np, decimal pv, decimal fv, string type1) {
        /*
         * ir   - interest rate per month
         * np   - number of periods (months)
         * pv   - present value
         * fv   - future value
         * type - when the payments are due:
         *        0: end of the period, e.g. end of month (default)
         *        1: beginning of period
         */


        if ((pv == null) || (fv == null)) {
            return null;
        }

        system.debug('ir ' + ir);
        system.debug('np ' + np);
        system.debug('pv ' + pv);

        system.debug('fv ' + fv);

        system.debug('type1 ' + type1);


        Double pmt;
        Double pvif;

        double ir1 = 1;

        if (!string.IsBlank(ir)) {
            if (np.equalsIgnoreCase('0')) {
                ir1 = 1;
            } else {
                ir1 = double.valueOf(ir);
            }
        } else {
            ir1 = 1;
        }

        double np1 = 1;

        if (!string.IsBlank(np)) {
            if (np.equalsIgnoreCase('0')) {
                np1 = 1;
            } else {
                np1 = double.valueOf(np);
            }
        } else {
            np1 = 1;
        }


        double pv1 = double.valueOf(pv);

        double fv1 = double.valueOf( - fv);

        system.debug(' double fv1' + fv1);
        system.debug(' double pvif' + pvif);

        if (((Math.pow(1 + ir1, np1) - 1) * -(pv1 * Math.pow(1 + ir1, np1) +  fv1)) == 0) {
            pmt = 0;
        } else {
            pmt = ir1 / (Math.pow(1 + ir1, np1) - 1) * -(pv1 * Math.pow(1 + ir1, np1) +  fv1);
        }


        system.debug('pmt' + pmt);

        if (!string.isBlank(type1) && type1.equals('1')) {
            pmt = pmt /(1 + ir1);
        }


        Decimal amount = pmt * -1;
        Decimal returnamount = amount.setscale(2);

        system.debug('returnamount' + returnamount);

        return returnamount;
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal CalculatePaymentAmount(decimal FinancedAmount, string Frequency, integer Term, string PaymentPeriod, decimal ExternalBrokerageRate, decimal InternalBrokerageRate, decimal MarginRate, decimal SwapRate, decimal RV, decimal DocumentationFees,  boolean IncludeDocFee) {

        decimal TotalBrokerageRate;
        decimal TotalBrokerageAmount;

        decimal TotalInterestRate;
        decimal FutureValue;
        decimal NoOfPayments;
        string PaymentPeriodType;
        decimal PresentValue;

        //get the Total Brokerage Rate
        TotalBrokerageRate = getTotalBrokerageRate(InternalBrokerageRate,ExternalBrokerageRate);
        TotalBrokerageAmount = getTotalBrokerageAmount(TotalBrokerageRate, FinancedAmount);

        //get the Total Interest Rate
        TotalInterestRate = getInterestRate(MarginRate, SwapRate,Frequency);

        //get the Future Value
        FutureValue = getFutureValue(RV, FinancedAmount);

        //get the total Financed Amount
        PresentValue = getTotalPresentValue(TotalBrokerageAmount, FinancedAmount, DocumentationFees, IncludeDocFee);

        //Call the Calculator function PMT
        NoOfPayments         = getNoOfPayments(term, Frequency);
        PaymentPeriodType     = getPaymentPeriodType(PaymentPeriod);
        return PMT(string.ValueOf(TotalInterestRate), string.ValueOf(NoOfPayments), PresentValue, FutureValue, PaymentPeriodType);

    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal excludeGSTFromDocFee( decimal GSTRate, decimal DocumentationFees) {
        if (GSTRate == null || GSTRate == 0.0) {
            return null;
        }

        if (DocumentationFees == null || DocumentationFees == 0.0) {
            return 0.0;
        }

        GSTRate = 1 + (GSTRate/100);
        GSTRate = GSTRate.setScale(2);

        return DocumentationFees / GSTRate;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal getTotalPresentValue( decimal BrokerageAmount, decimal FinanceAmount, decimal DocumentationFees, boolean IncludeDocFee) {

        decimal TotalSolutionCost;

        if (BrokerageAmount != null) {
            TotalSolutionCost = FinanceAmount + BrokerageAmount;
        } else {
            TotalSolutionCost = FinanceAmount;
        }

        if (FinanceAmount != null && IncludeDocFee) {
            TotalSolutionCost += DocumentationFees;
        }

        return TotalSolutionCost;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal getNoOfPayments(decimal term, string Frequency) {
        decimal noOfPayments= 0;
        if (Frequency.equalsIgnoreCase(GlobalConstants.MONTHLY))
            noOfPayments= term ;
        else
            noOfPayments = term/3;

        return (double) noOfPayments;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal getTotalBrokerageRate(decimal InternalBrokerage, decimal ExternalBrokerage) {
        decimal TotalBrokerageRate =0.0;
        system.debug('TotalBrokerageRate ' + TotalBrokerageRate);
        system.debug('InternalBrokerage ' + InternalBrokerage);
        system.debug('ExternalBrokerage ' + ExternalBrokerage);

        TotalBrokerageRate = InternalBrokerage +ExternalBrokerage;
        return TotalBrokerageRate;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal getTotalBrokerageAmount(decimal TotalBrokerageRate, decimal FinanceAmount) {
        decimal TotalBrokerageAmount = (TotalBrokerageRate/100) * FinanceAmount;
        return TotalBrokerageAmount;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal getInterestRate(decimal MarginRate, decimal SwapRate, string Frequency) {
        decimal TotalInterest = MarginRate + SwapRate;
        decimal InterestRate;

        if (Frequency.equalsIgnoreCase(GlobalConstants.MONTHLY)) {
            InterestRate = (TotalInterest/100) * 1/12;
        } else {
            InterestRate = (TotalInterest/100) * 1/4;
        }

        return InterestRate;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static decimal getFutureValue(decimal RV, decimal FinanceAmount) {
        decimal FutureValue;
        FutureValue = (RV/100) * FinanceAmount;
        return FutureValue;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    global static string getPaymentPeriodType(string PaymentPeriod) {
        if (PaymentPeriod.equalsIgnoreCase('Advance')) {
            return '1';
        } else {
            return '0';
        }

        return'';
    }
}