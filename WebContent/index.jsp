<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E-Commerce Site</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script
            src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #E6F9E6;">

<%
/* Checking the user credentials */
String userName = (String) session.getAttribute("username");
String password = (String) session.getAttribute("password");
String userType = (String) session.getAttribute("usertype");

boolean isValidUser = true;

if (userType == null || userName == null || password == null || !userType.equals("customer")) {
    isValidUser = false;
}

ProductServiceImpl prodDao = new ProductServiceImpl();
List<ProductBean> products = new ArrayList<ProductBean>();

String search = request.getParameter("search");
String type = request.getParameter("type");
String message = "All Products";
if (search != null) {
    products = prodDao.searchAllProducts(search);
    message = "Showing Results for '" + search + "'";
} else if (type != null) {
    products = prodDao.getAllProductsByType(type);
    message = "Showing Results for '" + type + "'";
} else {
    products = prodDao.getAllProducts();
}
if (products.isEmpty()) {
    message = "No items found for the search '" + (search != null ? search : type) + "'";
    products = prodDao.getAllProducts();
}
%>

<header role="banner">
    <jsp:include page="header.jsp" />
</header>

<nav role="navigation">
    <!-- Your navigation menu here -->
</nav>

<main role="main">
    <div class="text-center"
         style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
    <div class="text-center" id="message"
         style="color: black; font-size: 14px; font-weight: bold;"></div>
    <!-- Start of Product Items List -->
    <div class="container">
        <div class="row text-center">
            <%
            for (ProductBean product : products) {
                int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
            %>
            <div class="col-sm-4" style='height: 350px;'>
                <div class="thumbnail" tabindex="0">
                    <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
                         style="height: 150px; max-width: 180px">
                    <p class="productname"><%=product.getProdName()%>
                    </p>
                    <%
                    String description = product.getProdInfo();
                    description = description.substring(0, Math.min(description.length(), 100));
                    %>
                    <p class="productinfo"><%=description%>..
                    </p>
                    <p class="price">
                        Rs
                        <%=product.getProdPrice()%>
                    </p>
                    <form method="post">
                        <%
                        if (cartQty == 0) {
                        %>
                        <button type="submit"
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
                                class="btn btn-success">Add to Cart</button>
                        &nbsp;&nbsp;&nbsp;
                        <button type="submit"
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
                                class="btn btn-primary">Buy Now</button>
                        <%
                        } else {
                        %>
                        <button type="submit"
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
                                class="btn btn-danger">Remove From Cart</button>
                        &nbsp;&nbsp;&nbsp;
                        <button type="submit" formaction="cartDetails.jsp"
                                class="btn btn-success">Checkout</button>
                        <%
                        }
                        %>
                    </form>
                    <br />
                </div>
            </div>
            <%
            }
            %>
        </div>
    </div>
    <!-- ENd of Product Items List -->
</main>

<footer role="contentinfo">
    <%@ include file="footer.html"%>
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Function to handle keyboard navigation
        function handleKeyboardNavigation(event) {
            // Get the key code of the pressed key
            var keyCode = event.keyCode || event.which;

            // Define the key codes for navigation
            var arrowUp = 38;
            var arrowDown = 40;

            // Get all the product thumbnails
            var thumbnails = document.querySelectorAll(".thumbnail");

            // Find the currently focused thumbnail
            var focusedIndex = Array.from(thumbnails).findIndex(function(thumbnail) {
                return thumbnail === document.activeElement;
            });

            // Handle navigation based on arrow keys
            switch(keyCode) {
                case arrowUp:
                    // Move focus to the previous thumbnail
                    if (focusedIndex > 0) {
                        thumbnails[focusedIndex - 1].focus();
                    }
                    break;
                case arrowDown:
                    // Move focus to the next thumbnail
                    if (focusedIndex < thumbnails.length - 1) {
                        thumbnails[focusedIndex + 1].focus();
                    }
                    break;
                // Add more cases for other key codes if needed
            }
        }

        // Attach keydown event listener to the document
        document.addEventListener("keydown", handleKeyboardNavigation);
    });
</script>

</body>
</html>
