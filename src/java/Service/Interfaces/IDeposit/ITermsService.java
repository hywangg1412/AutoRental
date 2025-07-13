package Service.Interfaces.IDeposit;

import java.sql.SQLException;

import Model.Entity.Deposit.Terms;

public interface ITermsService {
    Terms getActiveDepositTerms() throws SQLException;
} 