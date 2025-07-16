package Service.External;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Map;
import org.xhtmlrenderer.pdf.ITextRenderer;

public class ContractDocumentService {
 
    public String renderContractJspToHtml(HttpServletRequest request, HttpServletResponse response, String bookingId) throws Exception {
        request.setAttribute("bookingId", bookingId);
        // Set other attributes as needed (e.g., userSignature, userFullName, ...)
        StringWriter stringWriter = new StringWriter();
        HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
            private PrintWriter writer = new PrintWriter(stringWriter);
            @Override
            public PrintWriter getWriter() { return writer; }
        };
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contract/contract-template.jsp");
        dispatcher.include(request, responseWrapper);
        return stringWriter.toString();
    }

 
    public byte[] htmlToPdf(String html) throws Exception {
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        ITextRenderer renderer = new ITextRenderer();
        renderer.setDocumentFromString(html);
        renderer.layout();
        renderer.createPDF(os);
        return os.toByteArray();
    }
    
    public Map uploadPdfToCloudinary(byte[] pdfBytes, String bookingId) throws IOException {
        CloudinaryService cloudinaryService = new CloudinaryService();
        // Use resource_type 'raw' for PDF files
        String fileName = "contract_" + bookingId;
        Map uploadResult = cloudinaryService.uploadFileToFolder(pdfBytes, "contracts", "contract_" + bookingId);
        String pdfUrl = (String) uploadResult.get("url");
        return uploadResult;
    }
}
