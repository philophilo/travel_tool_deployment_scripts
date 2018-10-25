apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ NAMESPACE }}
spec:
  minReadySeconds: 15
  revisionHistoryLimit: 3
  template:
    metadata:
      labels:
        app: {{ PROJECT_NAME }}
    spec:
      containers:
        - name: {{ PROJECT_NAME }}
          image: {{ DOCKER_REGISTRY }}/{{ PROJECT_ID }}/{{ PROJECT_NAME }}:{{ IMAGE_TAG }}
          imagePullPolicy: Always
          command:
            - node
            - index.js
          ports:
          - containerPort: {{ PORT }}
            name: http
          env:
            - name: PORT
              value: "{{ PORT }}"
            - name: NODE_ENV
              value: {{ NAMESPACE }}
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DatabaseUrl
            - name: JWT_PUBLIC_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: JwtPublicKey
            - name: DEFAULT_ADMIN
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DefaultAdmin
            - name: REDIRECT_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: RedirectUrl
            - name: BUGSNAG_API_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: BugsnagApiKey
            - name: MAILGUN_API_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: MailgunApiKey
            - name: MAILGUN_DOMAIN_NAME
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: MailgunDomainName
            - name: MAIL_SENDER
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: MailSender
            - name: SURVEY_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: SurveyUrl
          readinessProbe:
            httpGet:
              path: /api/v1/_healthz
              port: http
            periodSeconds: 10
            timeoutSeconds: 10
            successThreshold: 1
            failureThreshold: 10
          livenessProbe:
            httpGet:
              path: /api/v1/_healthz
              port: http
            initialDelaySeconds: 10
