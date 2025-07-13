package Service.Deposit;

import java.sql.SQLException;

import Model.Entity.Deposit.Terms;
import Repository.Deposit.TermsRepository;
import Service.Interfaces.IDeposit.ITermsService;

public class TermsService implements ITermsService {
    private final TermsRepository termsRepository = new TermsRepository();

    @Override
    public Terms getActiveDepositTerms() throws SQLException {
        return termsRepository.findActiveTerms();
    }
} 