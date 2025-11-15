class ProfileState {
  final String username;
  final String email;
  final String? imagePath;
  final bool isLoading;
  final bool isProcessing;

  const ProfileState({
    this.username = '',
    this.email = '',
    this.imagePath,
    this.isLoading = true,
    this.isProcessing = false,
  });

  ProfileState copyWith({
    String? username,
    String? email,
    String? imagePath,
    bool? isLoading,
    bool? isProcessing,
  }) {
    return ProfileState(
      username: username ?? this.username,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
