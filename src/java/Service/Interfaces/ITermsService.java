package Service.Interfaces;

import Model.Entity.Deposit.Terms;

/**
 * Interface cho TermsService
 */
public interface ITermsService {
    
    /**
     * Lấy điều khoản hiện tại cho deposit
     * @return Terms entity hiện tại
     * @throws Exception
     */
    Terms getActiveDepositTerms() throws Exception;
} 