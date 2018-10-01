# This is the backend service
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress-lb
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  externalTrafficPolicy: Local
  type: LoadBalancer
  loadBalancerIP: {{ STATIC_IP }}
  ports:
  - port: 80
    name: http
    targetPort: 80
  - port: 443
    name: https
    targetPort: 443
  selector:
    # Selects nginx-ingress-controller pods
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
