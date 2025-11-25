import { jest } from '@jest/globals';

// Mock bcrypt
const bcryptMock = {
  hash: jest.fn(),
  compare: jest.fn()
};

// Mock model
const modelMock = {
  findByEmail: jest.fn(),
  insert: jest.fn(),
  findAll: jest.fn(),
  findByKeyword: jest.fn(),
  updateUsername: jest.fn(),
  findById: jest.fn(),
  updatePassword: jest.fn(),
  deleteById: jest.fn()
};

// Mock token generator
const tokenMock = jest.fn();

// Setup mocks before imports
jest.unstable_mockModule('bcrypt', () => ({
  default: bcryptMock,
  ...bcryptMock
}));

jest.unstable_mockModule('../src/models/user-model.js', () => ({
  default: modelMock
}));

jest.unstable_mockModule('../src/helpers/generate-token.js', () => ({
  default: tokenMock
}));

// Dynamic imports after mocking
const { default: AppError } = await import('../src/helpers/app-error.js');
const { default: service } = await import('../src/services/user-service.js');

describe('User Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('signUp', () => {
    const mockUser = {
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123'
    };

    it('should create a new user successfully', async () => {
      modelMock.findByEmail.mockResolvedValue(null);
      bcryptMock.hash.mockResolvedValue('hashedPassword');
      modelMock.insert.mockResolvedValue({ id: '1', ...mockUser });

      const result = await service.signUp(mockUser);

      expect(modelMock.findByEmail).toHaveBeenCalledWith({ email: mockUser.email });
      expect(bcryptMock.hash).toHaveBeenCalledWith(mockUser.password, 10);
      expect(modelMock.insert).toHaveBeenCalledWith({
        username: mockUser.username,
        email: mockUser.email,
        password: 'hashedPassword'
      });
      expect(result).toEqual({ id: '1', ...mockUser });
    });

    it('should throw error if email already exists', async () => {
      modelMock.findByEmail.mockResolvedValue({ email: mockUser.email });

      await expect(service.signUp(mockUser)).rejects.toThrow(
        new AppError('Email already used', 409)
      );
      expect(bcryptMock.hash).not.toHaveBeenCalled();
      expect(modelMock.insert).not.toHaveBeenCalled();
    });

    it('should throw error if insert fails', async () => {
      modelMock.findByEmail.mockResolvedValue(null);
      bcryptMock.hash.mockResolvedValue('hashedPassword');
      modelMock.insert.mockRejectedValue(new Error('Database error'));

      await expect(service.signUp(mockUser)).rejects.toThrow(
        new AppError('Failed to create user', 500)
      );
    });
  });

  describe('signIn', () => {
    const mockCredentials = {
      email: 'test@example.com',
      password: 'password123'
    };

    const mockUser = {
      id: '1',
      email: 'test@example.com',
      username: 'testuser',
      password: 'hashedPassword'
    };

    it('should sign in user successfully', async () => {
      modelMock.findByEmail.mockResolvedValue(mockUser);
      bcryptMock.compare.mockResolvedValue(true);
      tokenMock.mockReturnValue('generated-token');

      const result = await service.signIn(mockCredentials);

      expect(modelMock.findByEmail).toHaveBeenCalledWith({ email: mockCredentials.email });
      expect(bcryptMock.compare).toHaveBeenCalledWith(mockCredentials.password, mockUser.password);
      expect(tokenMock).toHaveBeenCalledWith({
        payload: { id: mockUser.id, email: mockUser.email }
      });
      expect(result).toEqual({
        id: mockUser.id,
        email: mockUser.email,
        username: mockUser.username,
        token: 'generated-token'
      });
    });

    it('should throw error if email not found', async () => {
      modelMock.findByEmail.mockResolvedValue(null);

      await expect(service.signIn(mockCredentials)).rejects.toThrow(
        new AppError('Email not found', 404)
      );
      expect(bcryptMock.compare).not.toHaveBeenCalled();
    });

    it('should throw error if password is wrong', async () => {
      modelMock.findByEmail.mockResolvedValue(mockUser);
      bcryptMock.compare.mockResolvedValue(false);

      await expect(service.signIn(mockCredentials)).rejects.toThrow(
        new AppError('Password is wrong', 400)
      );
      expect(tokenMock).not.toHaveBeenCalled();
    });
  });

  describe('getAllUser', () => {
    it('should return all users', async () => {
      const mockUsers = [
        { id: '1', email: 'user1@example.com', username: 'user1' },
        { id: '2', email: 'user2@example.com', username: 'user2' }
      ];
      modelMock.findAll.mockResolvedValue(mockUsers);

      const result = await service.getAllUser();

      expect(modelMock.findAll).toHaveBeenCalled();
      expect(result).toEqual(mockUsers);
    });

    it('should throw error if no users found', async () => {
      modelMock.findAll.mockResolvedValue([]);

      await expect(service.getAllUser()).rejects.toThrow(
        new AppError('User is empty', 404)
      );
    });
  });

  describe('searchUser', () => {
    it('should return users matching keyword', async () => {
      const mockUsers = [
        { id: '1', email: 'test@example.com', username: 'testuser' }
      ];
      modelMock.findByKeyword.mockResolvedValue(mockUsers);

      const result = await service.searchUser('test');

      expect(modelMock.findByKeyword).toHaveBeenCalledWith('test');
      expect(result).toEqual(mockUsers);
    });

    it('should throw error if no users found', async () => {
      modelMock.findByKeyword.mockResolvedValue([]);

      await expect(service.searchUser('nonexistent')).rejects.toThrow(
        new AppError('User not found', 404)
      );
    });

    it('should throw error if result is null', async () => {
      modelMock.findByKeyword.mockResolvedValue(null);

      await expect(service.searchUser('test')).rejects.toThrow(
        new AppError('User not found', 404)
      );
    });
  });

  describe('updateUsername', () => {
    it('should update username successfully', async () => {
      const mockUpdate = { matchedCount: 1, modifiedCount: 1 };
      modelMock.updateUsername.mockResolvedValue(mockUpdate);

      const result = await service.updateUsername({
        email: 'test@example.com',
        username: 'newusername'
      });

      expect(modelMock.updateUsername).toHaveBeenCalledWith({
        email: 'test@example.com',
        username: 'newusername'
      });
      expect(result).toEqual(mockUpdate);
    });

    it('should throw error if update fails', async () => {
      modelMock.updateUsername.mockResolvedValue({ matchedCount: 0 });

      await expect(service.updateUsername({
        email: 'test@example.com',
        username: 'newusername'
      })).rejects.toThrow(new AppError('Failed update username', 400));
    });

    it('should throw error if result is null', async () => {
      modelMock.updateUsername.mockResolvedValue(null);

      await expect(service.updateUsername({
        email: 'test@example.com',
        username: 'newusername'
      })).rejects.toThrow(new AppError('Failed update username', 400));
    });
  });

  describe('updatePassword', () => {
    const mockUser = {
      id: '1',
      email: 'test@example.com',
      password: 'hashedOldPassword'
    };

    it('should update password successfully', async () => {
      modelMock.findByEmail.mockResolvedValue(mockUser);
      bcryptMock.compare.mockResolvedValue(true);
      bcryptMock.hash.mockResolvedValue('hashedNewPassword');
      modelMock.updatePassword.mockResolvedValue({ modifiedCount: 1 });

      const result = await service.updatePassword({
        email: 'test@example.com',
        passwordOld: 'oldPassword',
        passwordNew: 'newPassword'
      });

      expect(modelMock.findByEmail).toHaveBeenCalledWith({ email: mockUser.email });
      expect(bcryptMock.compare).toHaveBeenCalledWith('oldPassword', mockUser.password);
      expect(bcryptMock.hash).toHaveBeenCalledWith('newPassword', 10);
      expect(modelMock.updatePassword).toHaveBeenCalledWith({
        email: mockUser.email,
        password: 'hashedNewPassword'
      });
      expect(result).toEqual({ modifiedCount: 1 });
    });

    it('should throw error if user not found', async () => {
      modelMock.findByEmail.mockResolvedValue(null);

      await expect(service.updatePassword({
        email: 'test@example.com',
        passwordOld: 'oldPassword',
        passwordNew: 'newPassword'
      })).rejects.toThrow(new AppError('User not found', 404));
    });

    it('should throw error if old password is wrong', async () => {
      modelMock.findByEmail.mockResolvedValue(mockUser);
      bcryptMock.compare.mockResolvedValue(false);

      await expect(service.updatePassword({
        email: 'test@example.com',
        passwordOld: 'wrongPassword',
        passwordNew: 'newPassword'
      })).rejects.toThrow(new AppError('Password is wrong', 400));
    });

    it('should throw error if password update fails', async () => {
      modelMock.findByEmail.mockResolvedValue(mockUser);
      bcryptMock.compare.mockResolvedValue(true);
      bcryptMock.hash.mockResolvedValue('hashedNewPassword');
      modelMock.updatePassword.mockResolvedValue({ modifiedCount: 0 });

      await expect(service.updatePassword({
        email: 'test@example.com',
        passwordOld: 'oldPassword',
        passwordNew: 'newPassword'
      })).rejects.toThrow(new AppError('Failed to update password', 500));
    });
  });

  describe('deleteUserById', () => {
    const mockUser = {
      id: '1',
      email: 'test@example.com',
      username: 'testuser'
    };

    it('should delete user successfully', async () => {
      modelMock.findById.mockResolvedValue(mockUser);
      modelMock.deleteById.mockResolvedValue({ deletedCount: 1 });

      const result = await service.deleteUserById({ id: '1' });

      expect(modelMock.findById).toHaveBeenCalledWith({ id: '1' });
      expect(modelMock.deleteById).toHaveBeenCalledWith({ id: mockUser.id });
      expect(result).toEqual({ deletedCount: 1 });
    });

    it('should throw error if user not found', async () => {
      modelMock.findById.mockResolvedValue(null);

      await expect(service.deleteUserById({ id: '1' })).rejects.toThrow(
        new AppError('User not found', 404)
      );
      expect(modelMock.deleteById).not.toHaveBeenCalled();
    });

    it('should throw error if delete fails', async () => {
      modelMock.findById.mockResolvedValue(mockUser);
      modelMock.deleteById.mockResolvedValue({ deletedCount: 0 });

      await expect(service.deleteUserById({ id: '1' })).rejects.toThrow(
        new AppError('Delete user failed', 500)
      );
    });
  });
});