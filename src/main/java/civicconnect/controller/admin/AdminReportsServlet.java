package civicconnect.controller.admin;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Complaint;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import civicconnect.utils.DateUtil;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/admin/reports")
public class AdminReportsServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int adminUserId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(adminUserId);
        Integer municipalityId = adminUser.getMunicipalityId();

        if (municipalityId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No municipality assigned.");
            return;
        }

        // Fetch ALL complaints for this municipality as DTOs (includes category names)
        ArrayList<ComplaintDTO> allComplaints = complaintDAO.getPublicComplaintsByMunicipality(
                municipalityId, null, null, null, "latest"
        );

        int totalComplaints = allComplaints.size();

        // 1. Complaints by Status
        long pendingCount = 0, inProgressCount = 0, resolvedCount = 0;
        for (ComplaintDTO c : allComplaints) {
            if ("pending".equalsIgnoreCase(c.getStatus())) pendingCount++;
            else if ("in_progress".equalsIgnoreCase(c.getStatus())) inProgressCount++;
            else if ("resolved".equalsIgnoreCase(c.getStatus())) resolvedCount++;
        }
        
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("resolvedCount", resolvedCount);
        
        double pendingPct = totalComplaints > 0 ? (pendingCount * 100.0) / totalComplaints : 0;
        double inProgressPct = totalComplaints > 0 ? (inProgressCount * 100.0) / totalComplaints : 0;
        double resolvedPct = totalComplaints > 0 ? (resolvedCount * 100.0) / totalComplaints : 0;
        
        request.setAttribute("pendingPct", pendingPct);
        request.setAttribute("inProgressPct", inProgressPct);
        request.setAttribute("resolvedPct", resolvedPct);

        // 2. Complaints by Category
        Map<String, Long> categoryCounts = allComplaints.stream()
                .collect(Collectors.groupingBy(
                        c -> c.getCategoryName() != null ? c.getCategoryName() : "Unknown",
                        Collectors.counting()
                ));
        request.setAttribute("categoryCounts", categoryCounts);

        // 3. Most Reported Wards (Sort by count DESC)
        Map<Integer, Long> wardCounts = allComplaints.stream()
                .collect(Collectors.groupingBy(ComplaintDTO::getWardNumber, Collectors.counting()));
        
        Map<Integer, Long> sortedWardCounts = wardCounts.entrySet().stream()
                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));
                
        request.setAttribute("wardCounts", sortedWardCounts);

        // 4. Most Supported Issues (Top 10)
        List<ComplaintDTO> topSupported = allComplaints.stream()
                .sorted((c1, c2) -> Integer.compare(c2.getVoteCount(), c1.getVoteCount()))
                .limit(10)
                .collect(Collectors.toList());
        request.setAttribute("topSupported", topSupported);

        // 5. Recent Activity (7 days, 30 days)
        LocalDateTime sevenDaysAgo = DateUtil.daysAgo(7);
        LocalDateTime thirtyDaysAgo = DateUtil.daysAgo(30);

        long newLast7Days = allComplaints.stream().filter(c -> c.getCreatedAt().isAfter(sevenDaysAgo)).count();
        long newLast30Days = allComplaints.stream().filter(c -> c.getCreatedAt().isAfter(thirtyDaysAgo)).count();
        
        // Count resolved in last 7/30 days
        long resolvedLast7Days = allComplaints.stream()
                .filter(c -> "resolved".equalsIgnoreCase(c.getStatus()) && c.getUpdatedAt() != null && c.getUpdatedAt().isAfter(sevenDaysAgo))
                .count();
        long resolvedLast30Days = allComplaints.stream()
                .filter(c -> "resolved".equalsIgnoreCase(c.getStatus()) && c.getUpdatedAt() != null && c.getUpdatedAt().isAfter(thirtyDaysAgo))
                .count();

        request.setAttribute("newLast7Days", newLast7Days);
        request.setAttribute("newLast30Days", newLast30Days);
        request.setAttribute("resolvedLast7Days", resolvedLast7Days);
        request.setAttribute("resolvedLast30Days", resolvedLast30Days);

        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
    }
}
