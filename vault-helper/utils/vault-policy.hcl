path "sys/*" {
  policy = "deny"
}

path "secret/demo/*" {
  policy = "read"
}


path "pki/issue/demo-svc-cluster-local/*" {
  policy = "write"
}

path "pki/issue/demo-svc-cluster-local" {
  policy = "write"
}
