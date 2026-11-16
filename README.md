# maven-jars

A `scratch` image containing these Maven Central artifacts in `/jars`:

| Maven coordinates |
| --- |
| `com.fasterxml.jackson.core:jackson-databind:2.21.5` |
| `org.apache.tomcat.embed:tomcat-embed-core:11.0.25` |
| `org.apache.wss4j:wss4j-ws-security-dom:3.0.4` |
| `org.bouncycastle:bcprov-jdk18on:1.84` |
| `org.apache.httpcomponents.client5:httpclient5:5.5.2` |
| `org.apache.cxf:cxf-rt-ws-security:3.6.9` |
| `org.springframework.batch:spring-batch-core:5.2.5` |

Only the explicitly listed JARs are downloaded, without transitive dependencies.
These are independently requested artifacts, not a tested compatible runtime
dependency set. The image has no JVM, shell, or entrypoint.

## Publishing

GitHub Actions builds and verifies the image, then publishes it on pushes to
`main` and manual workflow runs. Authentication uses the built-in `GITHUB_TOKEN`
with `contents: read` and `packages: write`; no additional secret is required.

Image tags:

```text
ghcr.io/ciis0/maven-jars:latest
ghcr.io/ciis0/maven-jars:sha-<full-commit-sha>
```

The package is private by default. Pulling it outside Actions requires GHCR
authentication with access to the package.

## Vulnerability scanning

Every publishing workflow scans the built image with Trivy after pushing it.
The scan checks for known vulnerabilities, including those without a fix, at all
severity levels. Findings and scanner errors do not block publication; scanner
errors still fail the workflow so they remain visible.

Download the `trivy-report` artifact from the workflow run for the JSON report.
The report reflects the vulnerability database available at scan time.

## Usage

Copy the JARs into another image:

```dockerfile
COPY --from=ghcr.io/ciis0/maven-jars:latest /jars/ /jars/
```

Prefer the commit tag or image digest when reproducibility matters.

Build locally with Docker or Podman:

```sh
docker build -f Containerfile -t maven-jars .
```

Edit the coordinates in `Containerfile` to update the artifacts. If adding or
removing artifacts, update the expected JAR count in the workflow and this list.
