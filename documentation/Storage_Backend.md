# Storage Backends

<!-- TODO: Finish adding storage backends. -->

## [Azure](https://www.vaultproject.io/docs/configuration/storage/azure.html)

The Azure storage backend is used to persist Vault's data in an [Azure Storage Container](https://azure.microsoft.com/en-us/services/storage/). The storage container must already exist and the provided account credentials must have read and write permissions to the storage container.

```ruby
storage_type 'azure',
storage_options {
  accountName: 'my-storage-account',
  accountKey:  'abcd1234',
  container:   'container-efgh5678',
  environment: 'AzurePublicCloud',
}
```

## [Cassandra](https://www.vaultproject.io/docs/configuration/storage/cassandra.html)

The Cassandra storage backend is used to persist Vault's data in an [Apache Cassandra](http://cassandra.apache.org/) cluster.

```ruby
storage_type 'cassandra',
storage_options {
  hosts: 'localhost',
  consistency: 'LOCAL_QUORUM',
  protocol_version: '3',
}
```

## [FileSystem](https://www.vaultproject.io/docs/configuration/storage/filesystem.html)

The Filesystem storage backend stores Vault's data on the filesystem using a standard directory structure. It can be used for durable single server situations, or to develop locally where durability is not critical.

```ruby
storage_type 'file'
storage_options {
  path: '/mnt/vault/data',
}
```