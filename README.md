# Orders manager with Java

Order management solution, for retail stores. My second Full Stack app in 2020 😄.

Also, you can check out my first Full Stack app: [orders-manager-php](https://github.com/jhordyess/orders-manager-php).

## Description

This project is a web application for managing orders, customers, products, and suppliers. It was developed for a retail store.

The project was initially created using NetBeans IDE 8.2 in 2020 and later transitioned to VSCode in 2022. It uses Java 8 with JSP and Servlets and utilizes a MariaDB 10.4 database, while Apache Tomcat 8.5 serves as the server. Deployment can be easily accomplished using Docker.

For more information on deploying Tomcat applications, you can refer to this quick article: [tomcat-root-application](https://www.baeldung.com/tomcat-root-application).

Some of the features are:

- Manage customers, products, suppliers, and orders.
- Generate PDF invoices and order itineraries.
- Review customer and product details.
- Review order status: incoming, approved, shipped, payment debts, canceled.
- Review order location on a map.

### Technologies Used

- JS Libraries: [jQuery](https://jquery.com/), [ChartJS](https://www.chartjs.org/), [Datatables](https://datatables.net/), [Vue.js](https://vuejs.org/), [Fraction.js](https://github.com/infusion/Fraction.js/), [Leaflet](https://leafletjs.com/), [Date Range Picker](https://www.daterangepicker.com/)
- Programming Language: [Java](https://www.java.com/)
- CSS Libraries: [W3.CSS](https://www.w3schools.com/w3css/default.asp)
- Icon library: [Font Awesome](https://fontawesome.com/)
- Database: [MariaDB](https://mariadb.org/)
- Wiki world map: [OpenStreetMap](https://www.openstreetmap.org/)
- Typesetting system: [Latex](https://www.latex-project.org/)
- Project management tool: [Maven](https://maven.apache.org/)
- Server: [Apache Tomcat](https://tomcat.apache.org/)
- Dev Environment: [VSCode](https://code.visualstudio.com/) with [dev containers](https://code.visualstudio.com/docs/remote/containers) in [Zorin OS](https://zorinos.com/)

### Screenshots

![Dashboard](https://res.cloudinary.com/jhordyess/image/upload/v1662602748/orders-manager/java/dashboard.png)
![New order](https://res.cloudinary.com/jhordyess/image/upload/v1662602748/orders-manager/java/new_order.png)
![Order list](https://res.cloudinary.com/jhordyess/image/upload/v1662602747/orders-manager/java/order_list.png)
![Invoice with LaTeX](https://res.cloudinary.com/jhordyess/image/upload/v1662602747/orders-manager/java/order_invoice.png)
![DDBB with phpMyAdmin Designer](https://res.cloudinary.com/jhordyess/image/upload/v1662647758/orders-manager/java/ddbb.png)

## How to use for development

You can use the VSCode dev containers to run the project in a containerized environment.

You need to have installed [Docker](https://www.docker.com/) and [VSCode](https://code.visualstudio.com/), and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

1. Clone this repository

```bash
git clone git@github.com:jhordyess/orders-manager-java.git
```

2. Open the project in VSCode

```bash
code orders-manager-java
```

3. Create a `.env` file in the root folder by copying the example from the [`.env.example`](./.env.example) file.

4. Open the integrated terminal (Ctrl+Shift+`) and run the following command:

```bash
docker compose -f docker-compose.dev.yml up -d
```

5. Open the command palette (Ctrl+Shift+P) and select the option `Dev Containers: Open folder in Container`.

6. Select the folder `java-app` and wait for the container to be built.

7. Open the integrated terminal (Ctrl+Shift+`) and run the following command:

```bash
bash dev.sh
```

9. Open the browser and visit <http://localhost:8080/>

## How to use for production

To run the project in production mode, remember to create the `.env` file in the root folder by copying the example from the [`.env.example`](./.env.example) file.

Then, run the following command:

```bash
docker compose -f docker-compose.prod.yml up -d
```

To stop or remove the containers, use the following commands:

```bash
docker compose -f docker-compose.prod.yml down
```

Take note that this production configuration is just for testing purposes, and maybe need some changes to be used in a real production environment.

## To-Do

- The project was originally created in Spanish, and still needs to be translated.
- Migrate MariaDB 10.4 to 10.6(LTS).
- Migrate Tomcat 8.5 to 9 or 10 by upgrading Java version to 11 or 17.
- Unnecessary event field for order registry.
- Improve Dashboard
- Fix login, users and roles.

## Contribution

If you would like to contribute to the project, open an issue or make a pull request on the repository.

## License

© 2022 [Jhordyess](https://github.com/jhordyess). Under the [MIT](https://choosealicense.com/licenses/mit/) license. See the [LICENSE](./LICENSE) file for more details.

---

Made with 💪 by [Jhordyess](https://www.jhordyess.com/)
