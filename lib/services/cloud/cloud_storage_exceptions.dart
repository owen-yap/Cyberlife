class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateResultException extends CloudStorageException {}

class CouldNotGetAllResultsException extends CloudStorageException {}

class CouldNotUpdateResultException extends CloudStorageException {}

class CouldNotDeleteResultException extends CloudStorageException {}
