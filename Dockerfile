# # Use the khipu/openjdk17-alpine base image
# FROM khipu/openjdk17-alpine

# # Set the working directory inside the container.
# WORKDIR /app

# # Copy the pom.xml and any other necessary files for building the application
# COPY pom.xml /app/pom.xml

# # Copy the source code into the container
# COPY src /app/src

# # Install Maven (if not already included in the base image)
# RUN apk add --no-cache maven

# # Package the application using Maven
# RUN mvn clean package -DskipTests

# # Run the application
# CMD ["java", "-jar", "target/online-banking-system-0.0.1-SNAPSHOT.jar"]



# Use the khipu/openjdk17-alpine base image
FROM khipu/openjdk17-alpine

# Set working directory
WORKDIR /app

# Copy only the pom.xml first for caching dependencies
COPY pom.xml /app/pom.xml

# Install Maven and other required tools
RUN apk add --no-cache maven bash curl

# Optional: configure Maven settings to use central repository explicitly
RUN mkdir -p /root/.m2 && echo "<settings><mirrors><mirror><id>central</id><mirrorOf>*</mirrorOf><url>https://repo.maven.apache.org/maven2</url></mirror></mirrors></settings>" > /root/.m2/settings.xml

# Copy source code
COPY src /app/src

# Package the application using Maven
# Skip tests and Jacoco to avoid plugin resolution issues
RUN mvn clean package -DskipTests -Djacoco.skip=true

# Expose the default Spring Boot port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "target/online-banking-system-0.0.1-SNAPSHOT.jar"]
