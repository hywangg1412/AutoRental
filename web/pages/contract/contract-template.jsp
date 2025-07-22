<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>CAR RENTAL AGREEMENT</title>
    <style>
<%
    boolean isPdfExport = request.getAttribute("isPdfExport") != null && Boolean.TRUE.equals(request.getAttribute("isPdfExport"));
%>
        @font-face {
            font-family: 'Dancing Script';
            src: url('file:/l:/Workspace/SWP/AutoRental/web/assets/fonts/dancing_script/DancingScript-Regular.ttf');
        }
        
        /* Base styles */
        body { 
            font-family: 'Times New Roman', Times, serif; 
            margin: 0; 
            padding: 0;
            background: #f5f5f5;
            line-height: 1.4;
        }
        
        .center { text-align: center; }
        .bold { font-weight: bold; }
        .underline { text-decoration: underline; }
        .section-title { 
            margin-top: 16px; 
            margin-bottom: 8px;
            font-weight: bold; 
        }
        .indent { margin-left: 32px; }
        
        .contract-footer { margin-top: 32px; }
        ul { 
            margin-top: 8px; 
            margin-bottom: 8px;
            padding-left: 20px;
        }
        
        li {
            margin-bottom: 4px;
            line-height: 1.3;
        }
        
        .signature-name { 
            font-family: 'Dancing Script', cursive; 
            font-size: 2em; 
            font-weight: normal; 
        }
        .signature-label { 
            margin-top: 16px; 
            font-style: italic; 
        }

        <% if (isPdfExport) { %>
        /* Loại bỏ @font-face trong PDF export vì ITextRenderer sẽ load font từ Java */
        body, .contract-page, .section-title, .bold, ul, li, div, .signature-fullname {
            font-family: 'BeVietnam Pro', Arial, sans-serif !important;
        }
        
        /* Signature font - sẽ được load từ Java code */
        .signature-name {
            font-family: 'Dancing Script', 'Times New Roman', serif !important;
            font-size: 1.6em !important;
            line-height: 1.2 !important;
        }
        
        /* Fallback nếu không có font custom */
        .signature-name {
            font-family: 'Dancing Script', 'Times New Roman', serif !important;
        }
        
        /* Nếu không có Dancing Script, dùng font thường với style italic */
        .signature-name-fallback {
            font-family: 'BeVietnam Pro', Arial, sans-serif !important;
            font-style: italic !important;
            font-weight: bold !important;
        }
        
        body {
            background: #fff !important;
            margin: 0 !important;
            padding: 0 !important;
            line-height: 1.2 !important;
        }
        
        .contract-page {
            width: 100% !important;
            height: auto !important;
            min-height: auto !important;
            max-height: none !important;
            margin: 0 !important;
            background: #fff !important;
            box-shadow: none !important;
            padding: 8mm 15mm !important;
            box-sizing: border-box !important;
            page-break-after: always !important;
            display: block !important;
        }
        
        .contract-page:first-child {
            padding-top: 12mm !important;
        }
        
        .contract-page:last-child {
            page-break-after: avoid !important;
        }
        
        .signature-block {
            margin-top: 20px !important;
            width: 100% !important;
            display: table !important;
            table-layout: fixed !important;
            border-collapse: separate !important;
        }
        
        .signature {
            display: table-cell !important;
            width: 50% !important;
            text-align: center !important;
            vertical-align: top !important;
            padding: 0 10px !important;
        }
        
        /* Tối ưu cho in PDF */
        * {
            -webkit-print-color-adjust: exact !important;
            color-adjust: exact !important;
        }
        
        .section-title {
            margin-top: 8px !important;
            margin-bottom: 4px !important;
            page-break-after: avoid !important;
        }
        
        .bold {
            margin-top: 6px !important;
            margin-bottom: 3px !important;
            page-break-after: avoid !important;
        }
        
        ul {
            margin-top: 3px !important;
            margin-bottom: 6px !important;
            padding-left: 18px !important;
            page-break-inside: avoid !important;
        }
        
        li {
            margin-bottom: 2px !important;
            line-height: 1.2 !important;
            page-break-inside: avoid !important;
        }
        
        br {
            line-height: 1.1 !important;
        }
        
        div {
            margin-top: 0 !important;
            margin-bottom: 3px !important;
        }
        
<% } else { %>
        /* CSS for Web Display - Giữ nguyên @font-face */
        @font-face {
            font-family: 'Dancing Script';
            src: url('/assets/fonts/dancing_script/DancingScript-Regular.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }
        
        @font-face {
            font-family: 'BeVietnam Pro';
            src: url('/assets/fonts/be_vietnam/BeVietnamPro-Regular.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }
        
        body {
            background: #f5f5f5;
            font-family: 'BeVietnam Pro', Arial, sans-serif;
        }
        
        .contract-page {
            width: 210mm;
            min-height: 297mm;
            margin: 0 auto 24px auto;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20mm;
            box-sizing: border-box;
            page-break-after: always;
        }
        
        .signature-block {
            margin-top: 48px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        
        .signature {
            width: 45%;
            text-align: center;
        }
        
        .signature-name {
            font-family: 'Dancing Script', 'Times New Roman', serif;
            font-size: 2em;
            font-weight: normal;
        }
        
<% } %>

        /* Common print styles */
        @media print {
            body {
                background: #fff !important;
                margin: 0 !important;
                line-height: 1.2 !important;
            }
            
            .contract-page { 
                box-shadow: none !important; 
                margin: 0 !important;
                padding: 8mm 15mm !important;
                page-break-after: always !important;
                min-height: auto !important;
                max-height: none !important;
            }
            
            .contract-page:first-child {
                padding-top: 12mm !important;
            }
            
            .contract-page:last-child {
                page-break-after: avoid !important;
            }
            
            .signature-block {
                display: table !important;
                width: 100% !important;
                table-layout: fixed !important;
                margin-top: 20px !important;
            }
            
            .signature {
                display: table-cell !important;
                width: 50% !important;
                text-align: center !important;
                vertical-align: top !important;
            }
            
            /* Tối ưu spacing cho print - Giảm khoảng cách */
            .section-title {
                margin-top: 8px !important;
                margin-bottom: 4px !important;
                page-break-after: avoid !important;
            }
            
            .bold {
                margin-top: 6px !important;
                margin-bottom: 3px !important;
                page-break-after: avoid !important;
            }
            
            ul {
                margin-top: 3px !important;
                margin-bottom: 6px !important;
                padding-left: 18px !important;
                page-break-inside: avoid !important;
            }
            
            li {
                margin-bottom: 2px !important;
                line-height: 1.2 !important;
                page-break-inside: avoid !important;
            }
            
            br {
                line-height: 1.1 !important;
            }
            
            div {
                margin-bottom: 3px !important;
            }
        }
        
        /* Fallback cho trường hợp Dancing Script không load được */
        @font-face {
            font-family: 'Dancing Script Fallback';
            src: local('Times New Roman'), local('Times'), serif;
        }
        
        .signature-name {
            font-family: 'Dancing Script', 'Dancing Script Fallback', 'Times New Roman', serif;
        }
    </style>
    <link href="https://fonts.googleapis.com/css?family=Dancing+Script&amp;display=swap" rel="stylesheet"/>
</head>
<body>
  <!-- Page 1: From start to end of Section 1 -->
  <div class="contract-page">
    <div class="center bold">SOCIALIST REPUBLIC OF VIETNAM</div>
    <div class="center">Independence – Freedom – Happiness</div>
    <div class="center">--------------o0o--------------</div>
    <div class="center section-title">CAR RENTAL AGREEMENT</div>
    <div class="center">(No:……/CRA)</div>
    <div style="margin: 8px 0;">- Pursuant to the Civil Code No. 91/2015/QH13 effective from 01/01/2017;</div>
    <div style="margin: 4px 0;">- Pursuant to the Commercial Law No. 36/2005/QH11 effective from 01/01/2006;</div>
    <div style="margin: 4px 0;">- Based on the needs and supply capabilities of both Parties.</div>
    <div class="section-title">SECTION 1: RIGHTS AND OBLIGATIONS OF PARTY A (Auto Rental)</div>
    <div class="bold">1.1. Rights of Party A (Auto Rental)</div>
    <ul>
        <li>Receive full rental payment as agreed.</li>
        <li>Upon contract expiration, has the right to reclaim the rented asset in its original agreed condition, except for normal wear and tear.</li>
        <li>In case of incidents during the trip requiring vehicle inspection or repair, Party A has the right to request Party B to participate in the process, including but not limited to: contacting insurance, joint assessment, and repair.</li>
        <li>Has the right to unilaterally terminate the contract and claim compensation if Party B uses the rented asset for purposes not agreed upon, damages or loses the asset, or sublets without Party A's consent.</li>
        <li>Request Party B to pay administrative fines incurred during the rental period. If Party B cannot pay, must provide their driver's license and prepay the fine for Party A to assist.</li>
        <li>For cases with a security deposit, Party A has the right to hold Party B's deposit from vehicle handover until all obligations and arising costs are settled.</li>
    </ul>
    <div class="bold">1.2. Obligations of Party A (Auto Rental)</div>
    <ul>
        <li>Be legally responsible for the origin and ownership of the vehicle.</li>
        <li>Deliver the correct vehicle and all related documents in safe and clean condition to ensure service quality for Party B. Related documents include: car registration (certified copy within 6 months), car inspection certificate (original), compulsory insurance (original).</li>
        <li>Deliver the vehicle at the agreed location and time. Before handover, verify renter's information and copy necessary identification documents for future contact.</li>
        <li>Be solely responsible if the contract is signed and the vehicle is handed over to a customer whose information does not match the agreement on the AutoRental application.</li>
        <li>For cases with a security deposit: (i) Party A is fully responsible for compensation if Party B's deposit is damaged due to Party A's fault; and (ii) Party A must return the full deposit to Party B after all obligations are fulfilled and all costs are paid (if any obligations remain, both Parties must record them in the Handover Minutes).</li>
    </ul>
  </div>
  
  <!-- Page 2: Section 2 -->
  <div class="contract-page">
    <div class="section-title">SECTION 2: RIGHTS AND OBLIGATIONS OF PARTY B</div>
    <div class="bold">2.1. Rights of Party B</div>
    <ul>
        <li>Receive the correct vehicle and related documents as per this Agreement.</li>
        <li>Repair the vehicle in urgent cases. In such cases, Party B must notify Party A of the vehicle's condition and issues before proceeding with repairs.</li>
        <li>Request Party A to repair if the vehicle is faulty due to Party A's fault or natural wear and tear; and claim compensation if Party A is late in delivery or delivers the wrong vehicle.</li>
        <li>Request Party A to provide invoices and documents for repair costs if Party A acts on behalf of Party B with the insurer or garage for damages caused by Party B.</li>
        <li>Unilaterally terminate the contract and claim compensation if Party A commits the following acts:
            <ul>
                <li>Party A delivers the vehicle late, except for force majeure (defined as circumstances beyond a Party's control: storms, epidemics, etc.). The Party invoking force majeure must prove it. If late delivery causes damage to Party B, compensation must be paid.</li>
                <li>The vehicle has defects preventing Party B from achieving the rental purpose, which Party B was unaware of.</li>
                <li>The vehicle is subject to ownership disputes between Party A and a third party, preventing Party B from using the vehicle as agreed.</li>
            </ul>
        </li>
    </ul>
    <div class="bold">2.2. Obligations of Party B</div>
    <ul>
        <li>Provide and be responsible for all necessary personal information and their driver's license as required at the beginning of the contract.</li>
        <li>Carefully inspect the vehicle before receiving and returning it. Take photos/videos of the vehicle's condition as evidence and sign confirmation upon receipt and return.</li>
        <li>Pay Party A the full rental fee upon receiving the vehicle and settle all additional charges at the time of return.</li>
        <li>Be responsible for personal belongings before returning the vehicle, ensuring nothing is left behind.</li>
        <li>For cases with a security deposit, Party B must provide the deposit before receiving the vehicle and be legally responsible for its origin and ownership, including: chip-based ID card/passport and 15 million VND in cash/motorbike registration.</li>
        <li>Comply with the vehicle return policy as agreed. If returning late, Party B must pay extra, calculated by hour/day as per Section 2 of this Agreement.</li>
        <li>Be liable for any loss of parts or accessories: 100% compensation at genuine part prices for swaps; 100% repair costs for damages caused by Party B, at a location designated by Party A or mutually agreed. For days the vehicle is out of service due to Party B's fault, Party B must pay the full rental price for those days. If the vehicle is not clean, Party B will bear the cleaning fee (or as mutually agreed).</li>
        <li>Strictly comply with traffic laws. Be civilly, criminally, and administratively liable during the rental period. Responsible for paying administrative fines during the rental period as notified by authorities.</li>
        <li>Absolutely not sublet or use the vehicle for illegal purposes: pawning, racing, smuggling, etc. Do not allow unqualified drivers. If Party A has grounds to suspect violations, Party A may unilaterally terminate the contract, notify the police, and take measures to recover the vehicle. Party B will be fully liable before the law and bear all arising costs.</li>
    </ul>
    <div class="section-title">SECTION 3: TRIP INSURANCE POLICY</div>
    <div class="bold">3.1. Insurance subjects and period:</div>
    <ul>
        <li>Applies only to trips with insurance purchased on the AutoRental app.</li>
        <li>The insurance period starts when Party B begins the trip and ends when the trip registered on AutoRental ends.</li>
    </ul>
    <div class="bold">3.2. Insurance coverage (see the insurance certificate in the trip information on the app):</div>
    <ul>
        <li>The insurer is responsible for compensating for material damages caused by natural disasters, unexpected accidents, collisions, etc. in the following cases:
            <ul>
                <li>Collision (including with non-motor vehicles)</li>
                <li>Fire, explosion</li>
                <li>Hydraulic shock (20% deductible, minimum 3,000,000 VND)</li>
            </ul>
        </li>
        <li>Deductible: 2,000,000 VND/case (excluding cases with reduced compensation as per insurer's regulations).</li>
    </ul>
    <div class="bold">3.3. Obligations:</div>
    <ul>
        <li>Take photos/videos of the vehicle's condition as evidence and sign confirmation upon receipt and return.</li>
        <li>For trips with insurance supported by Mioto, in case of an accident, Party B must keep the scene intact and immediately contact the insurer's hotline for instructions.</li>
        <li>Party B must notify Party A to stay informed and coordinate with Party A to handle the incident as instructed by the insurer.</li>
        <li>Party B is responsible for paying costs as per the insurer's regulations.</li>
        <li>If Party B causes an incident outside the insurance period or coverage or in excluded cases, leading to insurer's refusal to compensate, Party B must fully compensate Party A for all losses.</li>
        <li>Both Parties must comply with the insurer's policies, regulations, penalties, coverage, compensation, reductions, and exclusions.</li>
    </ul>
  </div>
  
  <!-- Page 3: Section 4 and Signatures -->
  <div class="contract-page">
    <div class="section-title">SECTION 4: GENERAL TERMS</div>
    <ul>
        <li>This Agreement, the Handover Minutes, and any appendices are integral parts of the Agreement. Both Parties must comply and cannot unilaterally amend, suspend, or cancel the Agreement. Any violation will be handled according to the law.</li>
        <li>During the execution of the Agreement, if issues arise, both Parties will discuss in a cooperative spirit and record in writing. If unresolved, the case will be brought to the competent People's Court. The losing Party will bear all costs.</li>
        <li>This Agreement automatically terminates when Party B returns the vehicle to Party A and both Parties have fulfilled all obligations.</li>
        <li>This Agreement takes effect from the time of signing and is made in 02 (two) copies, each Party keeps 01 (one) copy.</li>
    </ul>
    
    <div class="signature-block">
        <div class="signature">
            <div class="bold">PARTY A – CAR OWNER</div>
            <div>(Sign and full name)</div>
            <div class="signature-label">Signature:</div>
            <div class="signature-name">Huy</div>
            <div>Tran Quang Huy</div>
        </div>
        <div class="signature">
            <div class="bold">PARTY B – RENTER</div>
            <div>(Sign and full name)</div>
            <div class="signature-label">Signature:</div>
            <div class="signature-name" id="realtime-signature">
                <% 
                    Object userSignature = request.getAttribute("userSignature");
                    boolean isBase64 = false;
                    if (userSignature != null && userSignature.toString().startsWith("data:image")) {
                        isBase64 = true;
                    }
                %>
                <% if (isBase64) { %>
                    <img src="<%= userSignature %>" style="width:400px; height:180px;" />
                <% } else { %>
                    <%= userSignature != null ? userSignature : "" %>
                <% } %>
            </div>
            <img id="realtime-signature-image" style="max-width: 220px; max-height: 80px; display: none; margin: 0 auto;" />
            <canvas id="direct-signature-pad" width="220" height="80" style="display:none; border:1px dashed #aaa; background:#fafbfc;"></canvas>
            <button type="button" id="clearDirectSignature" style="display:none; margin-top:8px;">Clear</button>
            <div class="signature-fullname" id="realtime-fullname"><%= request.getAttribute("userFullName") != null ? request.getAttribute("userFullName") : "" %></div>
        </div>
    </div>
  </div>
</body>
<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.6/dist/signature_pad.umd.min.js"></script>
<script>
var signaturePad;
document.addEventListener('DOMContentLoaded', function() {
    var canvas = document.getElementById('direct-signature-pad');
    var clearBtn = document.getElementById('clearDirectSignature');
    if (canvas && window.SignaturePad) {
        signaturePad = new window.SignaturePad(canvas);
        clearBtn.addEventListener('click', function() {
            signaturePad.clear();
        });
    }
});

window.addEventListener('message', function (event) {
    if (event.data && event.data.type === 'SWITCH_SIGNATURE_METHOD') {
        var method = event.data.method;
        var img = document.getElementById('realtime-signature-image');
        var sig = document.getElementById('realtime-signature');
        if (method === 'draw') {
            if(img) img.style.display = 'block';
            if(sig) sig.style.display = 'none';
        } else {
            if(img) img.style.display = 'none';
            if(sig) sig.style.display = '';
        }
    }
    if (event.data && event.data.type === 'UPDATE_SIGNATURE') {
        var sig = document.getElementById('realtime-signature');
        if(sig) sig.textContent = event.data.signature || '';
        var img = document.getElementById('realtime-signature-image');
        if(img) img.style.display = 'none';
    }
    if (event.data && event.data.type === 'UPDATE_FULLNAME') {
        var fn = document.getElementById('realtime-fullname');
        if(fn) fn.textContent = event.data.fullName || '';
    }
    if (event.data && event.data.type === 'UPDATE_SIGNATURE_IMAGE') {
        var img = document.getElementById('realtime-signature-image');
        var sig = document.getElementById('realtime-signature');
        if (event.data.signatureImage) {
            if(img) {
                img.src = event.data.signatureImage;
                img.style.display = 'block';
            }
            if(sig) sig.textContent = '';
        } else {
            if(img) {
                img.src = '';
                img.style.display = 'none';
            }
        }
    }
});
</script>
</html>