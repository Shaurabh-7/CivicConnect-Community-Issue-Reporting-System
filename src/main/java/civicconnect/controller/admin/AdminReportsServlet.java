package civicconnect.controller.admin;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
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
import java.util.*;
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
                                municipalityId, null, null, null, "latest");

                int totalComplaints = allComplaints.size();

                // 1. Complaints by Status
                long pendingCount = 0, inProgressCount = 0, resolvedCount = 0;
                for (ComplaintDTO c : allComplaints) {
                        if ("pending".equalsIgnoreCase(c.getStatus()))
                                pendingCount++;
                        else if ("in_progress".equalsIgnoreCase(c.getStatus()))
                                inProgressCount++;
                        else if ("resolved".equalsIgnoreCase(c.getStatus()))
                                resolvedCount++;
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

                // 2. Complaints by Category (Simple Map accumulation)
                Map<String, Integer> categoryCounts = new HashMap<>();
                for (ComplaintDTO c : allComplaints) {
                        String catName = c.getCategoryName() != null ? c.getCategoryName() : "Unknown";
                        categoryCounts.put(catName, categoryCounts.getOrDefault(catName, 0) + 1);
                }
                request.setAttribute("categoryCounts", categoryCounts);

                // 3. Most Reported Wards (Simple Map accumulation & List sorting)
                Map<Integer, Integer> wardCounts = new HashMap<>();
                for (ComplaintDTO c : allComplaints) {
                        int ward = c.getWardNumber();
                        wardCounts.put(ward, wardCounts.getOrDefault(ward, 0) + 1);
                }
                
                List<Map.Entry<Integer, Integer>> wardEntryList = new ArrayList<>(wardCounts.entrySet());
                wardEntryList.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
                
                Map<Integer, Integer> sortedWardCounts = new LinkedHashMap<>();
                for (Map.Entry<Integer, Integer> entry : wardEntryList) {
                        sortedWardCounts.put(entry.getKey(), entry.getValue());
                }
                request.setAttribute("wardCounts", sortedWardCounts);

                // 4. Most Supported Issues (Top 10 sorted list)
                List<ComplaintDTO> topSupported = new ArrayList<>(allComplaints);
                topSupported.sort((c1, c2) -> Integer.compare(c2.getVoteCount(), c1.getVoteCount()));
                if (topSupported.size() > 10) {
                        topSupported = topSupported.subList(0, 10);
                }
                request.setAttribute("topSupported", topSupported);

                // 5. Recent Activity (Single-pass loop for 7 days, 30 days)
                LocalDateTime sevenDaysAgo = DateUtil.daysAgo(7);
                LocalDateTime thirtyDaysAgo = DateUtil.daysAgo(30);

                long newLast7Days = 0;
                long newLast30Days = 0;
                long resolvedLast7Days = 0;
                long resolvedLast30Days = 0;

                for (ComplaintDTO c : allComplaints) {
                        // New complaints in last 7 / 30 days
                        if (c.getCreatedAt() != null) {
                                if (c.getCreatedAt().isAfter(sevenDaysAgo)) {
                                        newLast7Days++;
                                }
                                if (c.getCreatedAt().isAfter(thirtyDaysAgo)) {
                                        newLast30Days++;
                                }
                        }
                        
                        // Resolved complaints in last 7 / 30 days
                        if ("resolved".equalsIgnoreCase(c.getStatus()) && c.getUpdatedAt() != null) {
                                if (c.getUpdatedAt().isAfter(sevenDaysAgo)) {
                                        resolvedLast7Days++;
                                }
                                if (c.getUpdatedAt().isAfter(thirtyDaysAgo)) {
                                        resolvedLast30Days++;
                                }
                        }
                }

                request.setAttribute("newLast7Days", newLast7Days);
                request.setAttribute("newLast30Days", newLast30Days);
                request.setAttribute("resolvedLast7Days", resolvedLast7Days);
                request.setAttribute("resolvedLast30Days", resolvedLast30Days);

                request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
        }
}
