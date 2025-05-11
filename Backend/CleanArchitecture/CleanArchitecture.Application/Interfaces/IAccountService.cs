﻿using CleanArchitecture.Core.DTOs.Account;
using CleanArchitecture.Core.DTOs.Email;
using CleanArchitecture.Core.Wrappers;
using System.Threading.Tasks;

namespace CleanArchitecture.Core.Interfaces
{
    public interface IAccountService
    {
        Task<AuthenticationResponse> AuthenticateAsync(AuthenticationRequest request, string ipAddress);
        Task<string> RegisterAsync(RegisterRequest request, string origin);
        Task<string> ConfirmEmailAsync(string userId, string code);
        Task<EmailRequest> ForgotPassword(ForgotPasswordRequest model, string origin);
        Task<string> ResetPassword(ResetPasswordRequest model);
        Task<string> UpdateEmailAsync(string userId, string newEmail);
        Task<string> UpdateNameAsync(string userId, string newFirstName, string newLastName);
        Task<string> UpdateUserNameAsync(string userId, string newUserName);
        Task<string> ChangePasswordAsync(string userId, string currentPassword, string newPassword);

    }
}
